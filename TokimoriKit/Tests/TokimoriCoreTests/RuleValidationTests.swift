import Foundation
import Testing
import TokimoriPlatform

@testable import TokimoriCore

let slack = AppReference(
  bundleID: "com.tinyspeck.slackmacgap", name: "Slack", path: "/Applications/Slack.app")

@Suite("App 规则冲突")
struct AppRuleConflictTests {
  let launch = AppRule(
    app: slack,
    time: WeeklyTime(weekdays: [.monday, .tuesday], time: TimeOfDay(hour: 9, minute: 0)),
    action: .launch)

  @Test("同一 App、同一分钟、星期有重叠、动作相反时冲突")
  func conflicting() {
    let quit = AppRule(
      app: slack, time: WeeklyTime(weekdays: [.tuesday], time: TimeOfDay(hour: 9, minute: 0)),
      action: .quit)
    #expect(quit.conflict(in: [launch]) == launch)
  }

  @Test("星期不重叠、时刻不同或动作相同都不算冲突")
  func notConflicting() {
    let otherDay = AppRule(
      app: slack, time: WeeklyTime(weekdays: [.friday], time: TimeOfDay(hour: 9, minute: 0)),
      action: .quit)
    let otherMinute = AppRule(
      app: slack, time: WeeklyTime(weekdays: [.monday], time: TimeOfDay(hour: 9, minute: 1)),
      action: .quit)
    let sameAction = AppRule(
      app: slack, time: WeeklyTime(weekdays: [.monday], time: TimeOfDay(hour: 9, minute: 0)),
      action: .launch)
    #expect(otherDay.conflict(in: [launch]) == nil)
    #expect(otherMinute.conflict(in: [launch]) == nil)
    #expect(sameAction.conflict(in: [launch]) == nil)
  }

  @Test("编辑已有规则时不和自己比")
  func editingItself() {
    var edited = launch
    edited.action = .quit
    #expect(edited.conflict(in: [launch]) == nil)
  }
}

@Suite("进程匹配")
struct ProcessMatcherTests {
  let processes = [
    ProcessEntry(name: "node", commandLine: "node /opt/homebrew/bin/claude --resume"),
    ProcessEntry(name: "ffmpeg", commandLine: nil),
  ]

  @Test("按进程名精确匹配，不区分大小写")
  func byName() {
    #expect(
      ProcessMatcher.matches(
        .process(pattern: "FFmpeg", matchesCommandLine: false), processes: processes,
        runningApps: []))
    #expect(
      !ProcessMatcher.matches(
        .process(pattern: "ffmpe", matchesCommandLine: false), processes: processes, runningApps: []
      ))
    #expect(
      !ProcessMatcher.matches(
        .process(pattern: "claude", matchesCommandLine: false), processes: processes,
        runningApps: []))
  }

  @Test("命令行包含时匹配命令行里的任意片段")
  func byCommandLine() {
    #expect(
      ProcessMatcher.matches(
        .process(pattern: "claude", matchesCommandLine: true), processes: processes, runningApps: []
      ))
    #expect(
      !ProcessMatcher.matches(
        .process(pattern: "codex", matchesCommandLine: true), processes: processes, runningApps: [])
    )
  }

  @Test("空白的匹配内容不匹配任何进程")
  func blank() {
    #expect(
      !ProcessMatcher.matches(
        .process(pattern: "  ", matchesCommandLine: true), processes: processes, runningApps: []))
  }

  @Test("App 规则按正在运行的 bundle id 匹配")
  func app() {
    #expect(ProcessMatcher.matches(.app(slack), processes: [], runningApps: [slack.bundleID]))
    #expect(!ProcessMatcher.matches(.app(slack), processes: [], runningApps: ["com.apple.Safari"]))
  }
}

@Suite("配置文件")
struct ConfigurationStoreTests {
  func temporaryStore() -> ConfigurationStore {
    let directory = FileManager.default.temporaryDirectory
      .appending(path: "tokimori-tests-\(UUID().uuidString)")
    return ConfigurationStore(url: directory.appending(path: "configuration.json"))
  }

  @Test("文件不存在时读出默认配置")
  func missing() throws {
    #expect(try temporaryStore().load() == Configuration())
  }

  @Test("写入再读出内容不变")
  func roundTrip() throws {
    let store = temporaryStore()
    var configuration = Configuration()
    configuration.appRules = [
      AppRule(
        app: slack, time: WeeklyTime(weekdays: [.monday], time: TimeOfDay(hour: 9, minute: 0)),
        action: .quit, quitFallback: .forceQuit)
    ]
    configuration.processRules = [
      ProcessRule(
        target: .process(pattern: "claude", matchesCommandLine: true), keepsDisplayOn: false)
    ]
    configuration.batteryProtection = BatteryProtection(isEnabled: false, threshold: 35)
    configuration.pausedSchedules = [UUID(): date(12, 18)]
    configuration.lastCheck = date(12, 10)
    try store.save(configuration)
    #expect(try store.load() == configuration)
  }

  @Test("缺少的字段按默认值补上")
  func partial() throws {
    let store = temporaryStore()
    try FileManager.default.createDirectory(
      at: store.url.deletingLastPathComponent(), withIntermediateDirectories: true)
    try Data(#"{"batteryProtection":{"isEnabled":true,"threshold":30}}"#.utf8).write(to: store.url)
    let loaded = try store.load()
    #expect(loaded.batteryProtection.threshold == 30)
    #expect(loaded.schedules.isEmpty)
  }
}
