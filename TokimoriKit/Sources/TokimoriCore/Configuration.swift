import Foundation

public struct Configuration: Codable, Equatable, Sendable {
  public var schedules: [ScheduleRule] = []
  public var processRules: [ProcessRule] = []
  public var appRules: [AppRule] = []
  public var batteryProtection = BatteryProtection()
  // 「停到时段结束」要在重启后继续有效，所以存进配置
  public var pausedSchedules: [UUID: Date] = [:]
  // 上次检查定时 App 动作的时刻；重新打开后据此找出关闭期间错过的动作
  public var lastCheck: Date?

  public init() {}

  // 新版本加字段后，旧配置文件缺的键按默认值补，不能因此读不出整个配置
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let defaults = Configuration()
    schedules =
      try container.decodeIfPresent(
        [ScheduleRule].self, forKey: .schedules) ?? defaults.schedules
    processRules =
      try container.decodeIfPresent(
        [ProcessRule].self, forKey: .processRules) ?? defaults.processRules
    appRules = try container.decodeIfPresent([AppRule].self, forKey: .appRules) ?? defaults.appRules
    batteryProtection =
      try container.decodeIfPresent(
        BatteryProtection.self, forKey: .batteryProtection) ?? defaults.batteryProtection
    pausedSchedules =
      try container.decodeIfPresent(
        [UUID: Date].self, forKey: .pausedSchedules) ?? defaults.pausedSchedules
    lastCheck = try container.decodeIfPresent(Date.self, forKey: .lastCheck)
  }
}

public struct ConfigurationStore: Sendable {
  public let url: URL

  public init(url: URL) {
    self.url = url
  }

  public static var standard: ConfigurationStore {
    let support = URL.applicationSupportDirectory.appending(path: "net.zhaojian.tokimori")
    return ConfigurationStore(url: support.appending(path: "configuration.json"))
  }

  public func load() throws -> Configuration {
    guard FileManager.default.fileExists(atPath: url.path) else { return Configuration() }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(Configuration.self, from: Data(contentsOf: url))
  }

  public func save(_ configuration: Configuration) throws {
    try FileManager.default.createDirectory(
      at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    try encoder.encode(configuration).write(to: url, options: .atomic)
  }
}
