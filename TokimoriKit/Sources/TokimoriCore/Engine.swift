import Foundation
import OSLog
import Observation
import TokimoriPlatform

public enum EngineEvent: Equatable, Sendable {
  case launchFailed(appName: String)
  case quitFailed(appName: String)
  case batteryStopped(threshold: Int)
}

public enum TurnOffChoice: Sendable {
  case pauseUntilEnd
  case disableRules
}

public struct ScheduledAppAction: Equatable, Sendable {
  public var date: Date
  public var rule: AppRule
}

@MainActor
@Observable
public final class Engine {
  // 睡眠或 Tokimori 没运行时错过的动作，超过这么久就不补了，免得开盖时执行一堆过时的启动和退出
  public static let missedActionGrace: TimeInterval = 10 * 60
  public static let quitTimeout: Duration = .seconds(30)

  public private(set) var configuration: Configuration
  public private(set) var manual: ManualSession?
  public private(set) var state = AwakeState()
  public private(set) var nextAppAction: ScheduledAppAction?
  public var onEvent: ((EngineEvent) -> Void)?

  private let store: ConfigurationStore?
  private let resolver: AwakeResolver
  private let calendar: Calendar
  private let assertions: PowerAssertions
  private let apps: AppControl
  private let processes: ProcessListing
  private let power: PowerSourceReading
  private let wait: @Sendable (Duration) async throws -> Void
  private var matchedProcessRules: Set<UUID> = []
  // 手动关闭时正在匹配的进程规则，暂停到那个进程结束为止
  private var pausedProcessRules: Set<UUID> = []
  private var battery: BatteryStatus?
  private var pendingActions: [UUID: Task<Void, Never>] = [:]
  @ObservationIgnored private let logger = Logger(
    subsystem: "net.zhaojian.tokimori", category: "engine")

  public init(
    configuration: Configuration, store: ConfigurationStore?, calendar: Calendar,
    assertions: PowerAssertions, apps: AppControl, processes: ProcessListing,
    power: PowerSourceReading, wait: @escaping @Sendable (Duration) async throws -> Void
  ) {
    self.configuration = configuration
    self.store = store
    self.calendar = calendar
    self.resolver = AwakeResolver(calendar: calendar)
    self.assertions = assertions
    self.apps = apps
    self.processes = processes
    self.power = power
    self.wait = wait
  }

  public var hasEnabledRules: Bool {
    configuration.schedules.contains(where: \.isEnabled)
      || configuration.processRules.contains(where: \.isEnabled)
      || configuration.appRules.contains(where: \.isEnabled)
  }

  // 返回下一次必须重新检查的时刻；进程和电量的变化没有时刻可算，由调用方定期刷新
  @discardableResult
  public func refresh(at now: Date) -> Date? {
    battery = power.status()
    let blocked = resolver.isBlockedByBattery(battery, configuration.batteryProtection)
    if blocked, !state.isBlockedByBattery {
      manual = nil
      if state.preventsSleep {
        onEvent?(.batteryStopped(threshold: configuration.batteryProtection.threshold))
      }
    }
    if let manual, !manual.isActive(at: now) { self.manual = nil }
    let expired = configuration.pausedSchedules.filter { $0.value <= now }
    if !expired.isEmpty {
      for id in expired.keys { configuration.pausedSchedules[id] = nil }
      save()
    }
    matchProcesses()
    runDueAppActions(at: now)
    apply(at: now)
    return nextDeadline(after: now)
  }

  // 以下改状态的方法都会顺带刷新，返回值和 refresh 一样是下一次检查时刻
  @discardableResult
  public func startManual(until: Date?, keepsDisplayOn: Bool, at now: Date) -> Date? {
    battery = power.status()
    guard !resolver.isBlockedByBattery(battery, configuration.batteryProtection) else {
      return refresh(at: now)
    }
    manual = ManualSession(until: until, keepsDisplayOn: keepsDisplayOn)
    return refresh(at: now)
  }

  @discardableResult
  public func setManualDisplay(_ keepsDisplayOn: Bool, at now: Date) -> Date? {
    guard manual != nil else { return refresh(at: now) }
    manual?.keepsDisplayOn = keepsDisplayOn
    return refresh(at: now)
  }

  public func activeSchedules(at now: Date) -> [(rule: ScheduleRule, interval: DateInterval)] {
    resolver.activeSchedules(inputs(at: now))
  }

  @discardableResult
  public func turnOff(_ choice: TurnOffChoice, at now: Date) -> Date? {
    manual = nil
    for (rule, interval) in activeSchedules(at: now) {
      switch choice {
      case .pauseUntilEnd:
        configuration.pausedSchedules[rule.id] = interval.end
      case .disableRules:
        if let index = configuration.schedules.firstIndex(where: { $0.id == rule.id }) {
          configuration.schedules[index].isEnabled = false
        }
      }
    }
    pausedProcessRules.formUnion(matchedProcessRules)
    save()
    return refresh(at: now)
  }

  @discardableResult
  public func update(at now: Date, _ change: (inout Configuration) -> Void) -> Date? {
    let before = configuration.schedules
    change(&configuration)
    // 删掉、改过或停用再启用的计划，原来的「停到时段结束」不再作数
    let unchanged = Set(configuration.schedules.filter(before.contains).map(\.id))
    configuration.pausedSchedules = configuration.pausedSchedules.filter {
      unchanged.contains($0.key)
    }
    save()
    return refresh(at: now)
  }

  // 正常退出时记下检查时刻，下次打开只补退出之后错过的动作
  public func prepareForQuit(at now: Date) {
    configuration.lastCheck = now
    save()
  }

  public func waitForPendingActions() async {
    let tasks = Array(pendingActions.values)
    for task in tasks { await task.value }
  }

  private func inputs(at now: Date) -> AwakeInputs {
    AwakeInputs(
      now: now, manual: manual, schedules: configuration.schedules,
      pausedSchedules: configuration.pausedSchedules, processRules: configuration.processRules,
      matchedProcessRules: matchedProcessRules, pausedProcessRules: pausedProcessRules,
      battery: battery, batteryProtection: configuration.batteryProtection)
  }

  private func apply(at now: Date) {
    state = resolver.resolve(inputs(at: now))
    assertions.update(preventsSleep: state.preventsSleep, keepsDisplayOn: state.keepsDisplayOn)
  }

  private func matchProcesses() {
    let rules = configuration.processRules.filter(\.isEnabled)
    guard !rules.isEmpty else {
      matchedProcessRules = []
      pausedProcessRules = []
      return
    }
    let needsProcesses = rules.contains { if case .process = $0.target { true } else { false } }
    let needsCommandLines = rules.contains {
      if case .process(_, true) = $0.target { true } else { false }
    }
    let running = apps.runningBundleIDs()
    let list = needsProcesses ? processes.processes(includingCommandLines: needsCommandLines) : []
    matchedProcessRules = Set(
      rules.filter { ProcessMatcher.matches($0.target, processes: list, runningApps: running) }
        .map(\.id))
    pausedProcessRules.formIntersection(matchedProcessRules)
  }

  private func runDueAppActions(at now: Date) {
    guard let last = configuration.lastCheck, last < now else {
      // 第一次运行或系统时间被往回调：从现在开始算，不追溯
      configuration.lastCheck = now
      return
    }
    let due = configuration.appRules.filter(\.isEnabled)
      .flatMap { rule in
        rule.time.occurrences(after: last, through: now, calendar: calendar).map { ($0, rule) }
      }
      .sorted { $0.0 < $1.0 }
    configuration.lastCheck = now
    guard !due.isEmpty else { return }
    // 处理过的动作一律落盘，崩溃重开后不会重复执行
    save()
    for (date, rule) in due {
      guard now.timeIntervalSince(date) <= Self.missedActionGrace else {
        logger.info("skipped missed action for \(rule.app.bundleID, privacy: .public)")
        continue
      }
      let id = UUID()
      pendingActions[id] = Task {
        await perform(rule)
        pendingActions[id] = nil
      }
    }
  }

  private func perform(_ rule: AppRule) async {
    let id = rule.app.bundleID
    switch rule.action {
    case .launch:
      guard !apps.runningBundleIDs().contains(id) else { return }
      if await !apps.launch(bundleID: id, path: rule.app.path) {
        onEvent?(.launchFailed(appName: rule.app.name))
      }
    case .quit:
      guard apps.runningBundleIDs().contains(id) else { return }
      _ = apps.terminate(bundleID: id)
      try? await wait(Self.quitTimeout)
      guard apps.runningBundleIDs().contains(id) else { return }
      switch rule.quitFallback {
      case .forceQuit:
        if !apps.forceTerminate(bundleID: id) { onEvent?(.quitFailed(appName: rule.app.name)) }
      case .notify:
        onEvent?(.quitFailed(appName: rule.app.name))
      }
    }
  }

  private func nextDeadline(after now: Date) -> Date? {
    let upcoming = configuration.appRules.filter(\.isEnabled)
      .compactMap { rule in
        rule.time.next(after: now, calendar: calendar).map {
          ScheduledAppAction(date: $0, rule: rule)
        }
      }
      .min { $0.date < $1.date }
    nextAppAction = upcoming
    let candidates: [Date?] =
      configuration.schedules.filter(\.isEnabled).map {
        $0.schedule.nextBoundary(after: now, calendar: calendar)
      } + Array(configuration.pausedSchedules.values) + [manual?.until, upcoming?.date]
    return candidates.compactMap { $0 }.filter { $0 > now }.min()
  }

  private func save() {
    guard let store else { return }
    do {
      try store.save(configuration)
    } catch {
      logger.error("saving configuration failed: \(error.localizedDescription, privacy: .public)")
    }
  }
}
