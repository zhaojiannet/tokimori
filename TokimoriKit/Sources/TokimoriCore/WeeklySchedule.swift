import Foundation

// 取值与 Calendar 的 weekday 分量一致，1 是周日
public enum Weekday: Int, Codable, CaseIterable, Comparable, Sendable {
  case sunday = 1
  case monday, tuesday, wednesday, thursday, friday, saturday

  public static func < (lhs: Weekday, rhs: Weekday) -> Bool { lhs.rawValue < rhs.rawValue }
}

public struct TimeOfDay: Codable, Hashable, Comparable, Sendable {
  public var hour: Int
  public var minute: Int

  public init(hour: Int, minute: Int) {
    self.hour = hour
    self.minute = minute
  }

  public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
    (lhs.hour, lhs.minute) < (rhs.hour, rhs.minute)
  }

  // 按当地钟点取当天的这个时刻；夏令时跳过的钟点落到之后第一个有效时刻
  func on(_ day: Date, calendar: Calendar) -> Date? {
    calendar.date(
      bySettingHour: hour, minute: minute, second: 0, of: day, matchingPolicy: .nextTime)
  }
}

// 需要按天往前后翻：跨午夜的时段可能从前一天开始
private func days(around date: Date, back: Int, forward: Int, calendar: Calendar) -> [Date] {
  let today = calendar.startOfDay(for: date)
  return (-back...forward).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
}

private func weekday(of day: Date, calendar: Calendar) -> Weekday? {
  Weekday(rawValue: calendar.component(.weekday, from: day))
}

public struct WeeklySchedule: Codable, Hashable, Sendable {
  public var weekdays: Set<Weekday>
  public var start: TimeOfDay
  // 不晚于 start 时表示结束在次日，相等即整整一天
  public var end: TimeOfDay

  public init(weekdays: Set<Weekday>, start: TimeOfDay, end: TimeOfDay) {
    self.weekdays = weekdays
    self.start = start
    self.end = end
  }

  public var endsNextDay: Bool { end <= start }

  private func intervals(around date: Date, back: Int, forward: Int, calendar: Calendar)
    -> [DateInterval]
  {
    days(around: date, back: back, forward: forward, calendar: calendar).compactMap { day in
      guard let weekday = weekday(of: day, calendar: calendar), weekdays.contains(weekday),
        let startDate = start.on(day, calendar: calendar),
        let endDay = endsNextDay ? calendar.date(byAdding: .day, value: 1, to: day) : day,
        let endDate = end.on(endDay, calendar: calendar), endDate > startDate
      else { return nil }
      return DateInterval(start: startDate, end: endDate)
    }
  }

  public func interval(containing date: Date, calendar: Calendar) -> DateInterval? {
    intervals(around: date, back: 1, forward: 0, calendar: calendar)
      .first { $0.start <= date && date < $0.end }
  }

  public func nextBoundary(after date: Date, calendar: Calendar) -> Date? {
    intervals(around: date, back: 1, forward: 7, calendar: calendar)
      .flatMap { [$0.start, $0.end] }
      .filter { $0 > date }
      .min()
  }
}

public struct WeeklyTime: Codable, Hashable, Sendable {
  public var weekdays: Set<Weekday>
  public var time: TimeOfDay

  public init(weekdays: Set<Weekday>, time: TimeOfDay) {
    self.weekdays = weekdays
    self.time = time
  }

  private func dates(around date: Date, back: Int, forward: Int, calendar: Calendar) -> [Date] {
    days(around: date, back: back, forward: forward, calendar: calendar).compactMap { day in
      guard let weekday = weekday(of: day, calendar: calendar), weekdays.contains(weekday)
      else { return nil }
      return time.on(day, calendar: calendar)
    }
  }

  public func occurrences(after start: Date, through end: Date, calendar: Calendar) -> [Date] {
    guard end > start else { return [] }
    let span = calendar.dateComponents([.day], from: start, to: end).day ?? 0
    return dates(around: start, back: 0, forward: span + 1, calendar: calendar)
      .filter { $0 > start && $0 <= end }
  }

  public func next(after date: Date, calendar: Calendar) -> Date? {
    dates(around: date, back: 0, forward: 7, calendar: calendar).first { $0 > date }
  }
}
