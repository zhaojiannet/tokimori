import Foundation
import Testing

@testable import TokimoriCore

let tokyo: Calendar = {
  var calendar = Calendar(identifier: .gregorian)
  calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
  return calendar
}()

// 2026-10-12 是周一
func date(
  _ day: Int, _ hour: Int, _ minute: Int = 0, month: Int = 10, calendar: Calendar = tokyo
) -> Date {
  calendar.date(
    from: DateComponents(year: 2026, month: month, day: day, hour: hour, minute: minute))!
}

let weekdays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]

@Suite("每周时段")
struct WeeklyScheduleTests {
  let workday = WeeklySchedule(
    weekdays: weekdays, start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 18, minute: 0))

  @Test("工作日时段内返回当天的起止时间")
  func insideWorkday() {
    let interval = workday.interval(containing: date(12, 10), calendar: tokyo)
    #expect(interval == DateInterval(start: date(12, 9), end: date(12, 18)))
  }

  @Test("开始时刻算在时段内，结束时刻不算")
  func boundaries() {
    #expect(workday.interval(containing: date(12, 9), calendar: tokyo) != nil)
    #expect(workday.interval(containing: date(12, 18), calendar: tokyo) == nil)
  }

  @Test("没勾选的星期不生效")
  func weekend() {
    #expect(workday.interval(containing: date(17, 10), calendar: tokyo) == nil)
  }

  @Test("跨午夜的时段算在开始那天，次日凌晨仍在时段内")
  func crossesMidnight() {
    let night = WeeklySchedule(
      weekdays: [.friday], start: TimeOfDay(hour: 22, minute: 0), end: TimeOfDay(hour: 2, minute: 0)
    )
    let expected = DateInterval(start: date(16, 22), end: date(17, 2))
    #expect(night.interval(containing: date(16, 23), calendar: tokyo) == expected)
    #expect(night.interval(containing: date(17, 1), calendar: tokyo) == expected)
    // 周四没勾，周五凌晨不属于任何时段
    #expect(night.interval(containing: date(16, 1), calendar: tokyo) == nil)
  }

  @Test("开始和结束相同表示整整 24 小时")
  func fullDay() {
    let allDay = WeeklySchedule(
      weekdays: [.monday], start: TimeOfDay(hour: 8, minute: 0), end: TimeOfDay(hour: 8, minute: 0))
    #expect(
      allDay.interval(containing: date(13, 7), calendar: tokyo)
        == DateInterval(start: date(12, 8), end: date(13, 8)))
  }

  @Test("下一个边界是最近的开始或结束时刻")
  func nextBoundary() {
    #expect(workday.nextBoundary(after: date(12, 10), calendar: tokyo) == date(12, 18))
    #expect(workday.nextBoundary(after: date(12, 18), calendar: tokyo) == date(13, 9))
    // 周五下班后，下一个边界是下周一 9 点
    #expect(workday.nextBoundary(after: date(16, 19), calendar: tokyo) == date(19, 9))
  }

  @Test("一个星期都没勾时没有边界")
  func noWeekdays() {
    let empty = WeeklySchedule(
      weekdays: [], start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 18, minute: 0))
    #expect(empty.nextBoundary(after: date(12, 10), calendar: tokyo) == nil)
  }

  @Test("夏令时切换当天按当地钟点计算")
  func daylightSaving() {
    var newYork = Calendar(identifier: .gregorian)
    newYork.timeZone = TimeZone(identifier: "America/New_York")!
    // 2026-11-01 周日凌晨 2 点回拨，当天有 25 小时
    let sunday = WeeklySchedule(
      weekdays: [.sunday], start: TimeOfDay(hour: 0, minute: 0), end: TimeOfDay(hour: 12, minute: 0)
    )
    let inside = date(1, 10, month: 11, calendar: newYork)
    let interval = sunday.interval(containing: inside, calendar: newYork)
    #expect(interval?.end == date(1, 12, month: 11, calendar: newYork))
    #expect(interval?.duration == TimeInterval(13 * 3600))
  }
}

@Suite("每周时刻")
struct WeeklyTimeTests {
  @Test("列出区间内的所有触发时刻，左开右闭")
  func occurrences() {
    let rule = WeeklyTime(weekdays: [.monday, .wednesday], time: TimeOfDay(hour: 9, minute: 30))
    #expect(
      rule.occurrences(after: date(12, 9, 30), through: date(14, 9, 30), calendar: tokyo)
        == [date(14, 9, 30)])
    #expect(
      rule.occurrences(after: date(12, 9), through: date(19, 9, 30), calendar: tokyo)
        == [date(12, 9, 30), date(14, 9, 30), date(19, 9, 30)])
  }

  @Test("下一次触发时刻")
  func next() {
    let rule = WeeklyTime(weekdays: [.friday], time: TimeOfDay(hour: 18, minute: 30))
    #expect(rule.next(after: date(12, 10), calendar: tokyo) == date(16, 18, 30))
    #expect(rule.next(after: date(16, 18, 30), calendar: tokyo) == date(23, 18, 30))
  }
}
