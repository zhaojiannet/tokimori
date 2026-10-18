import Foundation
import Testing
import TokimoriPlatform

@testable import TokimoriCore

@Suite("防睡眠状态合并")
struct AwakeResolverTests {
  let workday = ScheduleRule(
    name: "Workday",
    schedule: WeeklySchedule(
      weekdays: weekdays, start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 18, minute: 0)),
    keepsDisplayOn: false)
  let build = ProcessRule(
    target: .process(pattern: "ffmpeg", matchesCommandLine: false), keepsDisplayOn: true)

  func resolve(
    at now: Date,
    manual: ManualSession? = nil,
    schedules: [ScheduleRule] = [],
    pauses: [UUID: Date] = [:],
    processes: [ProcessRule] = [],
    matched: Set<UUID> = [],
    pausedProcesses: Set<UUID> = [],
    battery: BatteryStatus? = nil,
    protection: BatteryProtection = BatteryProtection()
  ) -> AwakeState {
    AwakeResolver(calendar: tokyo).resolve(
      AwakeInputs(
        now: now, manual: manual, schedules: schedules, pausedSchedules: pauses,
        processRules: processes, matchedProcessRules: matched,
        pausedProcessRules: pausedProcesses, battery: battery, batteryProtection: protection))
  }

  @Test("什么都没开时不防睡眠")
  func idle() {
    let state = resolve(at: date(12, 10))
    #expect(!state.preventsSleep)
    #expect(state.sources.isEmpty)
  }

  @Test("定时时段内防睡眠，来源带结束时间")
  func schedule() {
    let state = resolve(at: date(12, 10), schedules: [workday])
    #expect(state.preventsSleep)
    #expect(!state.keepsDisplayOn)
    #expect(state.sources == [.schedule(id: workday.id, name: "Workday", until: date(12, 18))])
  }

  @Test("停用的规则不生效")
  func disabledRule() {
    var rule = workday
    rule.isEnabled = false
    #expect(!resolve(at: date(12, 10), schedules: [rule]).preventsSleep)
  }

  @Test("暂停到时段结束前不生效，暂停过期后恢复")
  func paused() {
    #expect(
      !resolve(at: date(12, 10), schedules: [workday], pauses: [workday.id: date(12, 18)])
        .preventsSleep)
    #expect(
      resolve(at: date(13, 10), schedules: [workday], pauses: [workday.id: date(12, 18)])
        .preventsSleep)
  }

  @Test("屏幕常亮取所有来源的并集")
  func displayUnion() {
    let state = resolve(
      at: date(12, 10), manual: ManualSession(until: nil, keepsDisplayOn: false),
      schedules: [workday], processes: [build], matched: [build.id])
    #expect(state.preventsSleep)
    #expect(state.keepsDisplayOn)
    #expect(state.sources.count == 3)
  }

  @Test("首尾相连的时段算到最后一段结束，接连不断的算没有结束")
  func chainedPeriods() {
    let evening = ScheduleRule(
      name: "Evening",
      schedule: WeeklySchedule(
        weekdays: [.monday], start: TimeOfDay(hour: 18, minute: 0),
        end: TimeOfDay(hour: 22, minute: 0)),
      keepsDisplayOn: false)
    #expect(
      resolve(at: date(12, 10), schedules: [workday, evening]).latestEnd == date(12, 22))
    let always = ScheduleRule(
      name: "Always",
      schedule: WeeklySchedule(
        weekdays: Set(Weekday.allCases), start: TimeOfDay(hour: 0, minute: 0),
        end: TimeOfDay(hour: 0, minute: 0)),
      keepsDisplayOn: false)
    #expect(resolve(at: date(12, 10), schedules: [always]).latestEnd == nil)
  }

  @Test("所有来源都有结束时间时取最晚的，有一个没有就算不出")
  func latestEnd() {
    let manual = ManualSession(until: date(12, 19), keepsDisplayOn: false)
    #expect(
      resolve(at: date(12, 10), manual: manual, schedules: [workday]).latestEnd == date(12, 19))
    #expect(
      resolve(
        at: date(12, 10), schedules: [workday], processes: [build], matched: [build.id]
      ).latestEnd == nil)
    #expect(resolve(at: date(12, 10)).latestEnd == nil)
  }

  @Test("手动会话到期后不再算来源")
  func manualExpired() {
    let manual = ManualSession(until: date(12, 10), keepsDisplayOn: false)
    #expect(resolve(at: date(12, 9), manual: manual).preventsSleep)
    #expect(!resolve(at: date(12, 10), manual: manual).preventsSleep)
  }

  @Test("进程规则只在匹配且没被暂停时生效")
  func processRule() {
    #expect(!resolve(at: date(12, 10), processes: [build]).preventsSleep)
    #expect(resolve(at: date(12, 10), processes: [build], matched: [build.id]).preventsSleep)
    #expect(
      !resolve(
        at: date(12, 10), processes: [build], matched: [build.id], pausedProcesses: [build.id]
      ).preventsSleep)
  }

  @Test("用电池且电量低于阈值时全部停掉")
  func batteryCutoff() {
    let low = BatteryStatus(isOnBattery: true, level: 19)
    let state = resolve(
      at: date(12, 10), manual: ManualSession(until: nil, keepsDisplayOn: true),
      schedules: [workday], battery: low)
    #expect(!state.preventsSleep)
    #expect(!state.keepsDisplayOn)
    #expect(state.isBlockedByBattery)
  }

  @Test("接着电源、电量达到阈值或关掉保护时不拦")
  func batteryAllowed() {
    let manual = ManualSession(until: nil, keepsDisplayOn: false)
    #expect(
      resolve(
        at: date(12, 10), manual: manual, battery: BatteryStatus(isOnBattery: false, level: 5)
      )
      .preventsSleep)
    #expect(
      resolve(
        at: date(12, 10), manual: manual, battery: BatteryStatus(isOnBattery: true, level: 20)
      )
      .preventsSleep)
    #expect(
      resolve(
        at: date(12, 10), manual: manual, battery: BatteryStatus(isOnBattery: true, level: 5),
        protection: BatteryProtection(isEnabled: false, threshold: 20)
      ).preventsSleep)
  }

  @Test("没有电池的 Mac 不受电池保护影响")
  func desktop() {
    #expect(
      resolve(at: date(12, 10), manual: ManualSession(until: nil, keepsDisplayOn: false))
        .preventsSleep)
  }
}
