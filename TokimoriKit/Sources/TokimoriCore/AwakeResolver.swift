import Foundation
import TokimoriPlatform

public enum AwakeSource: Hashable, Sendable {
  case manual(until: Date?)
  case schedule(id: UUID, name: String, until: Date)
  case process(id: UUID, name: String)
}

public struct AwakeState: Equatable, Sendable {
  public var sources: [AwakeSource]
  public var keepsDisplayOn: Bool
  public var isBlockedByBattery: Bool
  // 防睡眠最早什么时候能结束；有来源没有结束时间，或者定时时段一段接一段停不下来时为 nil
  public var latestEnd: Date?

  public init(
    sources: [AwakeSource] = [], keepsDisplayOn: Bool = false, isBlockedByBattery: Bool = false,
    latestEnd: Date? = nil
  ) {
    self.sources = sources
    self.keepsDisplayOn = keepsDisplayOn
    self.isBlockedByBattery = isBlockedByBattery
    self.latestEnd = latestEnd
  }

  public var preventsSleep: Bool { !sources.isEmpty }
}

public struct AwakeInputs: Sendable {
  public var now: Date
  public var manual: ManualSession?
  public var schedules: [ScheduleRule]
  public var pausedSchedules: [UUID: Date]
  public var processRules: [ProcessRule]
  public var matchedProcessRules: Set<UUID>
  public var pausedProcessRules: Set<UUID>
  public var battery: BatteryStatus?
  public var batteryProtection: BatteryProtection

  public init(
    now: Date, manual: ManualSession?, schedules: [ScheduleRule], pausedSchedules: [UUID: Date],
    processRules: [ProcessRule], matchedProcessRules: Set<UUID>, pausedProcessRules: Set<UUID>,
    battery: BatteryStatus?, batteryProtection: BatteryProtection
  ) {
    self.now = now
    self.manual = manual
    self.schedules = schedules
    self.pausedSchedules = pausedSchedules
    self.processRules = processRules
    self.matchedProcessRules = matchedProcessRules
    self.pausedProcessRules = pausedProcessRules
    self.battery = battery
    self.batteryProtection = batteryProtection
  }
}

public struct AwakeResolver: Sendable {
  public var calendar: Calendar

  public init(calendar: Calendar) {
    self.calendar = calendar
  }

  public func isBlockedByBattery(_ battery: BatteryStatus?, _ protection: BatteryProtection)
    -> Bool
  {
    guard protection.isEnabled, let battery, battery.isOnBattery else { return false }
    return battery.level < protection.threshold
  }

  public func activeSchedules(_ inputs: AwakeInputs) -> [(
    rule: ScheduleRule, interval: DateInterval
  )] {
    inputs.schedules.compactMap { rule in
      guard rule.isEnabled,
        inputs.pausedSchedules[rule.id].map({ inputs.now >= $0 }) ?? true,
        let interval = rule.schedule.interval(containing: inputs.now, calendar: calendar)
      else { return nil }
      return (rule, interval)
    }
  }

  public func resolve(_ inputs: AwakeInputs) -> AwakeState {
    if isBlockedByBattery(inputs.battery, inputs.batteryProtection) {
      return AwakeState(isBlockedByBattery: true)
    }
    var sources: [AwakeSource] = []
    var display = false
    if let manual = inputs.manual, manual.isActive(at: inputs.now) {
      sources.append(.manual(until: manual.until))
      display = display || manual.keepsDisplayOn
    }
    for (rule, interval) in activeSchedules(inputs) {
      sources.append(.schedule(id: rule.id, name: rule.name, until: interval.end))
      display = display || rule.keepsDisplayOn
    }
    for rule in inputs.processRules
    where rule.isEnabled && inputs.matchedProcessRules.contains(rule.id)
      && !inputs.pausedProcessRules.contains(rule.id)
    {
      sources.append(.process(id: rule.id, name: rule.name))
      display = display || rule.keepsDisplayOn
    }
    return AwakeState(
      sources: sources, keepsDisplayOn: display, latestEnd: latestEnd(of: sources, inputs))
  }

  // 结束时刻正好有别的定时时段接上时要接着往后算；一周内都接不完就当作没有结束
  private func latestEnd(of sources: [AwakeSource], _ inputs: AwakeInputs) -> Date? {
    var ends: [Date] = []
    for source in sources {
      switch source {
      case .manual(let until?), .schedule(_, _, let until): ends.append(until)
      default: return nil
      }
    }
    guard var end = ends.max() else { return nil }
    var probe = inputs
    for _ in 0..<(7 * 24) {
      probe.now = end
      guard let next = activeSchedules(probe).map(\.interval.end).max(), next > end else {
        return end
      }
      end = next
    }
    return nil
  }
}
