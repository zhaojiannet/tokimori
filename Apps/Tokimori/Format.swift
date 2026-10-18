import Foundation
import TokimoriCore

enum Format {
  static func time(_ date: Date) -> String {
    date.formatted(date: .omitted, time: .shortened)
  }

  // 结束时间可能在明天，只有时刻会让人误会
  static func dayAndTime(_ date: Date) -> String {
    let calendar = Calendar.autoupdatingCurrent
    if calendar.isDateInToday(date) {
      return String(localized: "today at \(time(date))")
    }
    if calendar.isDateInTomorrow(date) {
      return String(localized: "tomorrow at \(time(date))")
    }
    return date.formatted(.dateTime.weekday(.wide).hour().minute())
  }

  static func time(_ time: TimeOfDay) -> String {
    let calendar = Calendar.autoupdatingCurrent
    let date =
      calendar.date(
        bySettingHour: time.hour, minute: time.minute, second: 0, of: .now) ?? .now
    return self.time(date)
  }

  static func duration(_ duration: Duration) -> String {
    duration.formatted(.units(allowed: [.hours, .minutes], width: .abbreviated))
  }

  static func remaining(until date: Date, from now: Date) -> String {
    let seconds = max(0, date.timeIntervalSince(now))
    // 秒数向上取整，免得还在防睡眠时显示 0:00
    return Duration.seconds(seconds).formatted(
      .time(pattern: .hourMinute(padHourToLength: 1, roundSeconds: .up)))
  }

  static func orderedWeekdays() -> [Weekday] {
    let first = Calendar.autoupdatingCurrent.firstWeekday
    return (0..<7).compactMap { Weekday(rawValue: (first - 1 + $0) % 7 + 1) }
  }

  static func shortName(_ weekday: Weekday) -> String {
    Calendar.autoupdatingCurrent.shortWeekdaySymbols[weekday.rawValue - 1]
  }

  static func weekdays(_ days: Set<Weekday>) -> String {
    let workdays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    switch days {
    case Set(Weekday.allCases): return String(localized: "Every day")
    case workdays: return String(localized: "Weekdays")
    case [.saturday, .sunday]: return String(localized: "Weekends")
    case []: return String(localized: "No days")
    default:
      return orderedWeekdays().filter(days.contains).map(shortName).joined(separator: " ")
    }
  }

  static func span(_ schedule: WeeklySchedule) -> String {
    let range = "\(time(schedule.start))–\(time(schedule.end))"
    return schedule.endsNextDay ? String(localized: "\(range) (next day)") : range
  }
}
