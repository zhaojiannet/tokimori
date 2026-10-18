import AppKit
import OSLog
import Observation
import ServiceManagement
import TokimoriCore
import TokimoriPlatform

@Observable
final class AppModel {
  // 快捷指令的动作在本进程里执行，要拿到菜单正在用的同一个引擎
  static let shared = AppModel()

  // 进程和电量的变化没有通知可等，定期查一次
  private static let pollInterval: TimeInterval = 30

  let engine: Engine
  private(set) var now = Date.now
  // 菜单栏沙漏正在翻转时的角度，0 到 180；不在翻转时为 nil
  private(set) var flipDegrees: CGFloat?
  @ObservationIgnored private var lastCycle: Int?
  @ObservationIgnored private var flipTimer: Timer?
  private let logger = Logger(subsystem: "net.zhaojian.tokimori", category: "app")
  @ObservationIgnored private var deadlineTimer: Timer?
  @ObservationIgnored private var pollTimer: Timer?
  @ObservationIgnored private var observers: [(NotificationCenter, NSObjectProtocol)] = []

  private init() {
    let (configuration, store) = Self.loadConfiguration(.standard)
    engine = Engine(
      configuration: configuration, store: store,
      calendar: .autoupdatingCurrent, assertions: IOKitPowerAssertions(name: "Tokimori"),
      apps: WorkspaceAppControl(), processes: LiveProcessListing(), power: LivePowerSource(),
      wait: { try await Task.sleep(for: $0) })
    engine.onEvent = { Notices.post($0) }
    observe()
    refresh()
  }

  // 读不出来的配置文件挪到一边再从空配置开始，不能直接覆盖掉用户的规则；
  // 挪不走时这次运行不写盘，原文件保持原样
  private static func loadConfiguration(_ store: ConfigurationStore) -> (
    Configuration, ConfigurationStore?
  ) {
    let logger = Logger(subsystem: "net.zhaojian.tokimori", category: "app")
    do {
      return (try store.load(), store)
    } catch {
      logger.error("configuration unreadable: \(error.localizedDescription, privacy: .public)")
      let stamp = Int(Date.now.timeIntervalSince1970)
      let aside = store.url.deletingPathExtension().appendingPathExtension("broken-\(stamp).json")
      do {
        try FileManager.default.moveItem(at: store.url, to: aside)
        return (Configuration(), store)
      } catch {
        logger.error("moving it aside failed: \(error.localizedDescription, privacy: .public)")
        return (Configuration(), nil)
      }
    }
  }

  func refresh() {
    schedule(engine.refresh(at: .now))
    // 沙漏每轮落完就翻过来；只在防睡眠一直开着、跨进新一轮时翻
    let cycle = Int(now.timeIntervalSinceReferenceDate / Hourglass.cycle)
    if let lastCycle, cycle != lastCycle, engine.state.preventsSleep { flip() }
    lastCycle = engine.state.preventsSleep ? cycle : nil
  }

  // 0.6 秒转半圈，缓入缓出；系统开了「减少动态效果」时直接换到下一轮开头
  private func flip() {
    guard !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion, flipTimer == nil else {
      return
    }
    let start = Date.now
    let duration: TimeInterval = 0.6
    let timer = Timer(timeInterval: 1.0 / 30, repeats: true) { _ in
      MainActor.assumeIsolated {
        let model = AppModel.shared
        let t = min(Date.now.timeIntervalSince(start) / duration, 1)
        let eased = t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
        if t >= 1 {
          model.flipTimer?.invalidate()
          model.flipTimer = nil
          model.flipDegrees = nil
        } else {
          model.flipDegrees = CGFloat(180 * eased)
        }
      }
    }
    RunLoop.main.add(timer, forMode: .common)
    flipTimer = timer
  }

  // 引擎改状态的方法会顺带刷新并给出下一次检查时刻，这里只负责按它设定时器
  private func schedule(_ next: Date?) {
    now = .now
    deadlineTimer?.invalidate()
    deadlineTimer = nil
    if let next {
      let timer = Timer(fire: next, interval: 0, repeats: false) { _ in
        MainActor.assumeIsolated { AppModel.shared.refresh() }
      }
      timer.tolerance = 1
      RunLoop.main.add(timer, forMode: .common)
      deadlineTimer = timer
    }
  }

  // 计时器在睡眠期间不走，醒来、改时间、改时区后都要重算；App 启动退出影响「App 运行期间」规则
  private func observe() {
    let workspace = NSWorkspace.shared.notificationCenter
    let names: [(NotificationCenter, Notification.Name)] = [
      (workspace, NSWorkspace.didWakeNotification),
      (workspace, NSWorkspace.didLaunchApplicationNotification),
      (workspace, NSWorkspace.didTerminateApplicationNotification),
      (.default, .NSSystemClockDidChange),
      (.default, .NSSystemTimeZoneDidChange),
    ]
    for (center, name) in names {
      let token = center.addObserver(forName: name, object: nil, queue: .main) { _ in
        MainActor.assumeIsolated { AppModel.shared.refresh() }
      }
      observers.append((center, token))
    }
    let quit = NotificationCenter.default.addObserver(
      forName: NSApplication.willTerminateNotification, object: nil, queue: .main
    ) { _ in
      MainActor.assumeIsolated { AppModel.shared.engine.prepareForQuit(at: .now) }
    }
    observers.append((.default, quit))
    let timer = Timer(timeInterval: Self.pollInterval, repeats: true) { _ in
      MainActor.assumeIsolated { AppModel.shared.refresh() }
    }
    timer.tolerance = 5
    RunLoop.main.add(timer, forMode: .common)
    pollTimer = timer
  }

  func start(for duration: Duration?) {
    let until = duration.map { Date.now.addingTimeInterval(TimeInterval($0.components.seconds)) }
    start(until: until)
  }

  func start(until: Date?) {
    start(until: until, keepsDisplayOn: Preferences.keepsDisplayOn)
  }

  // 电量过低或结束时刻已过时开不起来，返回 false
  @discardableResult
  func start(until: Date?, keepsDisplayOn: Bool) -> Bool {
    schedule(engine.startManual(until: until, keepsDisplayOn: keepsDisplayOn, at: .now))
    return engine.manual != nil
  }

  // 选的时刻已经过了就算明天的
  func start(untilTimeOfDay time: Date) {
    let calendar = Calendar.autoupdatingCurrent
    let parts = calendar.dateComponents([.hour, .minute], from: time)
    let target = calendar.nextDate(
      after: .now, matching: parts, matchingPolicy: .nextTime, direction: .forward)
    start(until: target)
  }

  func setKeepsDisplayOn(_ on: Bool) {
    Preferences.keepsDisplayOn = on
    schedule(engine.setManualDisplay(on, at: .now))
  }

  func turnOff() {
    let active = engine.activeSchedules(at: .now)
    guard !active.isEmpty else {
      schedule(engine.turnOff(.pauseUntilEnd, at: .now))
      return
    }
    guard let choice = Prompts.turnOff(active) else { return }
    schedule(engine.turnOff(choice, at: .now))
  }

  // 快捷指令没法弹框问，正在生效的定时一律按「停到本时段结束」处理
  func turnOffWithoutAsking() {
    schedule(engine.turnOff(.pauseUntilEnd, at: .now))
  }

  func updateRules(_ change: (inout Configuration) -> Void) {
    let hadRules = engine.hasEnabledRules
    schedule(engine.update(at: .now, change))
    if !hadRules, engine.hasEnabledRules, !Preferences.askedAboutLoginItem {
      Preferences.askedAboutLoginItem = true
      if Prompts.openAtLogin() { setOpensAtLogin(true) }
    }
  }

  // 待用户在系统设置里批准也算已开启：登记已经成功，开关不该弹回去
  var opensAtLogin: Bool {
    [.enabled, .requiresApproval].contains(SMAppService.mainApp.status)
  }

  var loginItemNeedsApproval: Bool { SMAppService.mainApp.status == .requiresApproval }

  func setOpensAtLogin(_ on: Bool) {
    do {
      if on {
        try SMAppService.mainApp.register()
      } else {
        try SMAppService.mainApp.unregister()
      }
    } catch {
      logger.error("login item change failed: \(error.localizedDescription, privacy: .public)")
      Prompts.loginItemFailed(error)
    }
  }

  func quit() {
    if engine.hasEnabledRules, !Preferences.suppressQuitWarning {
      guard Prompts.confirmQuit() else { return }
    }
    NSApp.terminate(nil)
  }
}

enum Preferences {
  private static let defaults = UserDefaults.standard

  static var keepsDisplayOn: Bool {
    get { defaults.bool(forKey: "keepsDisplayOn") }
    set { defaults.set(newValue, forKey: "keepsDisplayOn") }
  }

  static var askedAboutLoginItem: Bool {
    get { defaults.bool(forKey: "askedAboutLoginItem") }
    set { defaults.set(newValue, forKey: "askedAboutLoginItem") }
  }

  static var suppressQuitWarning: Bool {
    get { defaults.bool(forKey: "suppressQuitWarning") }
    set { defaults.set(newValue, forKey: "suppressQuitWarning") }
  }
}
