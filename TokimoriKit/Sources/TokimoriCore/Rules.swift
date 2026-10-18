import Foundation

public struct ScheduleRule: Codable, Hashable, Identifiable, Sendable {
  public var id: UUID
  public var name: String
  public var schedule: WeeklySchedule
  public var keepsDisplayOn: Bool
  public var isEnabled: Bool

  public init(
    id: UUID = UUID(), name: String, schedule: WeeklySchedule, keepsDisplayOn: Bool,
    isEnabled: Bool = true
  ) {
    self.id = id
    self.name = name
    self.schedule = schedule
    self.keepsDisplayOn = keepsDisplayOn
    self.isEnabled = isEnabled
  }
}

public struct AppReference: Codable, Hashable, Sendable {
  public var bundleID: String
  public var name: String
  // 只作提示用：App 换了位置时按 bundleID 重新找
  public var path: String

  public init(bundleID: String, name: String, path: String) {
    self.bundleID = bundleID
    self.name = name
    self.path = path
  }
}

public enum ProcessTarget: Codable, Hashable, Sendable {
  case app(AppReference)
  case process(pattern: String, matchesCommandLine: Bool)
}

public struct ProcessRule: Codable, Hashable, Identifiable, Sendable {
  public var id: UUID
  public var target: ProcessTarget
  public var keepsDisplayOn: Bool
  public var isEnabled: Bool

  public init(
    id: UUID = UUID(), target: ProcessTarget, keepsDisplayOn: Bool, isEnabled: Bool = true
  ) {
    self.id = id
    self.target = target
    self.keepsDisplayOn = keepsDisplayOn
    self.isEnabled = isEnabled
  }

  public var name: String {
    switch target {
    case .app(let app): app.name
    case .process(let pattern, _): pattern
    }
  }
}

public enum AppAction: String, Codable, Hashable, Sendable {
  case launch
  case quit
}

public enum QuitFallback: String, Codable, Hashable, Sendable {
  case notify
  case forceQuit
}

public struct AppRule: Codable, Hashable, Identifiable, Sendable {
  public var id: UUID
  public var app: AppReference
  public var time: WeeklyTime
  public var action: AppAction
  // 只对 quit 有意义
  public var quitFallback: QuitFallback
  public var isEnabled: Bool

  public init(
    id: UUID = UUID(), app: AppReference, time: WeeklyTime, action: AppAction,
    quitFallback: QuitFallback = .notify, isEnabled: Bool = true
  ) {
    self.id = id
    self.app = app
    self.time = time
    self.action = action
    self.quitFallback = quitFallback
    self.isEnabled = isEnabled
  }

  public func conflict(in rules: [AppRule]) -> AppRule? {
    rules.first { other in
      other.id != id && other.app.bundleID == app.bundleID && other.action != action
        && other.time.time == time.time && !other.time.weekdays.isDisjoint(with: time.weekdays)
    }
  }
}

public struct ManualSession: Codable, Hashable, Sendable {
  // nil 表示一直开着，直到手动关掉
  public var until: Date?
  public var keepsDisplayOn: Bool

  public init(until: Date?, keepsDisplayOn: Bool) {
    self.until = until
    self.keepsDisplayOn = keepsDisplayOn
  }

  public func isActive(at now: Date) -> Bool { until.map { now < $0 } ?? true }
}

public struct BatteryProtection: Codable, Hashable, Sendable {
  public var isEnabled: Bool
  // 百分比，电量低于它时停止
  public var threshold: Int

  public init(isEnabled: Bool = true, threshold: Int = 20) {
    self.isEnabled = isEnabled
    self.threshold = threshold
  }
}
