import Foundation
import Testing
import TokimoriPlatform

@testable import TokimoriCore

@MainActor
@Suite("调度引擎")
struct EngineTests {
  let assertions = FakeAssertions()
  let apps = FakeApps()
  let power = FakePower()
  let processes = FakeProcesses()

  let workday = ScheduleRule(
    name: "Workday",
    schedule: WeeklySchedule(
      weekdays: weekdays, start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 18, minute: 0)),
    keepsDisplayOn: false)

  func makeEngine(_ configuration: Configuration = Configuration()) -> (Engine, EventLog) {
    let log = EventLog()
    let engine = Engine(
      configuration: configuration, store: nil, calendar: tokyo, assertions: assertions,
      apps: apps, processes: processes, power: power, wait: { _ in })
    engine.onEvent = { log.events.append($0) }
    return (engine, log)
  }

  func appRule(
    _ action: AppAction, at hour: Int, _ minute: Int = 0, fallback: QuitFallback = .notify
  )
    -> AppRule
  {
    AppRule(
      app: slack, time: WeeklyTime(weekdays: weekdays, time: TimeOfDay(hour: hour, minute: minute)),
      action: action, quitFallback: fallback)
  }

  @Test("定时时段内打开断言，返回时段结束作为下次检查时间")
  func scheduleWindow() {
    var configuration = Configuration()
    configuration.schedules = [workday]
    let (engine, _) = makeEngine(configuration)
    let next = engine.refresh(at: date(12, 10))
    #expect(assertions.preventsSleep)
    #expect(next == date(12, 18))
    engine.refresh(at: date(12, 18))
    #expect(!assertions.preventsSleep)
  }

  @Test("手动会话到期后释放断言")
  func manualExpires() {
    let (engine, _) = makeEngine()
    engine.startManual(until: date(12, 11), keepsDisplayOn: true, at: date(12, 10))
    #expect(assertions.preventsSleep && assertions.keepsDisplayOn)
    engine.refresh(at: date(12, 11))
    #expect(!assertions.preventsSleep)
    #expect(engine.manual == nil)
  }

  @Test("错过的动作 10 分钟内补执行")
  func missedWithinGrace() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.launch, at: 9)]
    configuration.lastCheck = date(12, 8, 55)
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 9, 10))
    await engine.waitForPendingActions()
    #expect(apps.launched == [slack.bundleID])
  }

  @Test("错过超过 10 分钟就跳过，之后也不再执行")
  func missedBeyondGrace() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.launch, at: 9)]
    configuration.lastCheck = date(12, 8, 55)
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 9, 11))
    engine.refresh(at: date(12, 9, 12))
    await engine.waitForPendingActions()
    #expect(apps.launched.isEmpty)
  }

  @Test("第一次运行不补执行以前的动作")
  func firstRun() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.launch, at: 9)]
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 9, 5))
    await engine.waitForPendingActions()
    #expect(apps.launched.isEmpty)
    engine.refresh(at: date(13, 9))
    await engine.waitForPendingActions()
    #expect(apps.launched == [slack.bundleID])
  }

  @Test("App 已经在运行时不再启动")
  func alreadyRunning() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.launch, at: 9)]
    configuration.lastCheck = date(12, 8)
    apps.running = [slack.bundleID]
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 9))
    await engine.waitForPendingActions()
    #expect(apps.launched.isEmpty)
  }

  @Test("启动失败时报告")
  func launchFails() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.launch, at: 9)]
    configuration.lastCheck = date(12, 8)
    apps.launchSucceeds = false
    let (engine, log) = makeEngine(configuration)
    engine.refresh(at: date(12, 9))
    await engine.waitForPendingActions()
    #expect(log.events == [.launchFailed(appName: "Slack")])
  }

  @Test("App 按请求退出时不报告")
  func quitSucceeds() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.quit, at: 18)]
    configuration.lastCheck = date(12, 17)
    apps.running = [slack.bundleID]
    let (engine, log) = makeEngine(configuration)
    engine.refresh(at: date(12, 18))
    await engine.waitForPendingActions()
    #expect(apps.terminated == [slack.bundleID])
    #expect(log.events.isEmpty)
  }

  @Test("没退出且选了发通知时报告，不强制退出")
  func quitFailsNotify() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.quit, at: 18)]
    configuration.lastCheck = date(12, 17)
    apps.running = [slack.bundleID]
    apps.quitsWhenAsked = false
    let (engine, log) = makeEngine(configuration)
    engine.refresh(at: date(12, 18))
    await engine.waitForPendingActions()
    #expect(apps.forceTerminated.isEmpty)
    #expect(log.events == [.quitFailed(appName: "Slack")])
  }

  @Test("没退出且选了强制退出时强制退出")
  func quitFailsForce() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.quit, at: 18, fallback: .forceQuit)]
    configuration.lastCheck = date(12, 17)
    apps.running = [slack.bundleID]
    apps.quitsWhenAsked = false
    let (engine, log) = makeEngine(configuration)
    engine.refresh(at: date(12, 18))
    await engine.waitForPendingActions()
    #expect(apps.forceTerminated == [slack.bundleID])
    #expect(log.events.isEmpty)
  }

  @Test("App 没在运行时退出规则什么都不做")
  func quitNotRunning() async {
    var configuration = Configuration()
    configuration.appRules = [appRule(.quit, at: 18)]
    configuration.lastCheck = date(12, 17)
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 18))
    await engine.waitForPendingActions()
    #expect(apps.terminated.isEmpty)
  }

  @Test("下一次检查时间取最近的 App 动作")
  func nextAppAction() {
    var configuration = Configuration()
    configuration.appRules = [appRule(.quit, at: 18, 30)]
    configuration.schedules = [workday]
    let (engine, _) = makeEngine(configuration)
    #expect(engine.refresh(at: date(12, 18, 10)) == date(12, 18, 30))
    #expect(engine.nextAppAction?.date == date(12, 18, 30))
  }

  @Test("电量过低时停掉手动会话并报告，充上电后定时恢复、手动不恢复")
  func batteryProtection() {
    var configuration = Configuration()
    configuration.schedules = [workday]
    let (engine, log) = makeEngine(configuration)
    power.battery = BatteryStatus(isOnBattery: true, level: 50)
    engine.startManual(until: nil, keepsDisplayOn: false, at: date(12, 10))
    power.battery = BatteryStatus(isOnBattery: true, level: 10)
    engine.refresh(at: date(12, 10, 1))
    #expect(!assertions.preventsSleep)
    #expect(engine.manual == nil)
    #expect(log.events == [.batteryStopped(threshold: 20)])
    engine.refresh(at: date(12, 10, 2))
    #expect(log.events.count == 1)
    power.battery = BatteryStatus(isOnBattery: false, level: 10)
    engine.refresh(at: date(12, 10, 3))
    #expect(assertions.preventsSleep)
    #expect(
      engine.state.sources == [.schedule(id: workday.id, name: "Workday", until: date(12, 18))])
  }

  @Test("电量低时不能开启手动会话")
  func manualWhileBlocked() {
    let (engine, _) = makeEngine()
    power.battery = BatteryStatus(isOnBattery: true, level: 10)
    engine.startManual(until: nil, keepsDisplayOn: false, at: date(12, 10))
    #expect(!assertions.preventsSleep)
    #expect(engine.manual == nil)
  }

  @Test("关闭时选择停到时段结束：本时段不再生效，下个时段照常")
  func turnOffPause() {
    var configuration = Configuration()
    configuration.schedules = [workday]
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 10))
    engine.turnOff(.pauseUntilEnd, at: date(12, 10))
    #expect(!assertions.preventsSleep)
    #expect(engine.configuration.schedules[0].isEnabled)
    engine.refresh(at: date(13, 9))
    #expect(assertions.preventsSleep)
    #expect(engine.configuration.pausedSchedules.isEmpty)
  }

  @Test("改了计划或停用后重新启用，之前的暂停作废")
  func editClearsPause() {
    var configuration = Configuration()
    configuration.schedules = [workday]
    let (engine, _) = makeEngine(configuration)
    engine.turnOff(.pauseUntilEnd, at: date(12, 10))
    engine.update(at: date(12, 10, 1)) { $0.schedules[0].isEnabled = false }
    engine.update(at: date(12, 10, 2)) { $0.schedules[0].isEnabled = true }
    #expect(assertions.preventsSleep)

    engine.turnOff(.pauseUntilEnd, at: date(12, 11))
    engine.update(at: date(12, 11, 1)) {
      $0.schedules[0].schedule.end = TimeOfDay(hour: 20, minute: 0)
    }
    #expect(assertions.preventsSleep)
  }

  @Test("改别的设置时暂停照旧")
  func unrelatedEditKeepsPause() {
    var configuration = Configuration()
    configuration.schedules = [workday]
    let (engine, _) = makeEngine(configuration)
    engine.turnOff(.pauseUntilEnd, at: date(12, 10))
    engine.update(at: date(12, 10, 1)) { $0.batteryProtection.threshold = 30 }
    #expect(!assertions.preventsSleep)
  }

  @Test("关闭时选择停用规则")
  func turnOffDisable() {
    var configuration = Configuration()
    configuration.schedules = [workday]
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 10))
    engine.turnOff(.disableRules, at: date(12, 10))
    #expect(!engine.configuration.schedules[0].isEnabled)
    engine.refresh(at: date(13, 10))
    #expect(!assertions.preventsSleep)
  }

  @Test("关闭时正在匹配的进程规则暂停到进程结束")
  func turnOffProcess() {
    var configuration = Configuration()
    let rule = ProcessRule(
      target: .process(pattern: "ffmpeg", matchesCommandLine: false), keepsDisplayOn: false)
    configuration.processRules = [rule]
    let (engine, _) = makeEngine(configuration)
    processes.entries = [ProcessEntry(name: "ffmpeg", commandLine: nil)]
    engine.refresh(at: date(12, 10))
    #expect(assertions.preventsSleep)
    engine.turnOff(.pauseUntilEnd, at: date(12, 10))
    engine.refresh(at: date(12, 10, 1))
    #expect(!assertions.preventsSleep)
    processes.entries = []
    engine.refresh(at: date(12, 10, 2))
    processes.entries = [ProcessEntry(name: "ffmpeg", commandLine: nil)]
    engine.refresh(at: date(12, 10, 3))
    #expect(assertions.preventsSleep)
  }

  @Test("命令行规则才读取命令行")
  func commandLineRule() {
    var configuration = Configuration()
    configuration.processRules = [
      ProcessRule(
        target: .process(pattern: "claude", matchesCommandLine: true), keepsDisplayOn: false)
    ]
    processes.entries = [ProcessEntry(name: "node", commandLine: "node /usr/local/bin/claude")]
    let (engine, _) = makeEngine(configuration)
    engine.refresh(at: date(12, 10))
    #expect(assertions.preventsSleep)
  }

  @Test("改配置会保存到文件")
  func persists() throws {
    let store = ConfigurationStore(
      url: FileManager.default.temporaryDirectory.appending(
        path: "tokimori-\(UUID().uuidString).json"))
    let engine = Engine(
      configuration: Configuration(), store: store, calendar: tokyo, assertions: assertions,
      apps: apps, processes: processes, power: power, wait: { _ in })
    engine.update(at: date(12, 10)) { $0.schedules = [workday] }
    #expect(try store.load().schedules == [workday])
    #expect(assertions.preventsSleep)
  }
}

@MainActor
final class EventLog {
  var events: [EngineEvent] = []
}
