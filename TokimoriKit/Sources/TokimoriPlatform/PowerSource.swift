import Foundation
import IOKit.ps

public struct BatteryStatus: Equatable, Sendable {
  public var isOnBattery: Bool
  // 0 到 100
  public var level: Int

  public init(isOnBattery: Bool, level: Int) {
    self.isOnBattery = isOnBattery
    self.level = level
  }
}

public protocol PowerSourceReading: Sendable {
  // 没有内置电池的 Mac 返回 nil
  func status() -> BatteryStatus?
}

public struct LivePowerSource: PowerSourceReading {
  public init() {}

  public func status() -> BatteryStatus? {
    let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(info).takeRetainedValue() as [CFTypeRef]
    for source in sources {
      guard
        let description = IOPSGetPowerSourceDescription(info, source)?.takeUnretainedValue()
          as? [String: Any],
        description[kIOPSTypeKey] as? String == kIOPSInternalBatteryType,
        let current = description[kIOPSCurrentCapacityKey] as? Int,
        let maximum = description[kIOPSMaxCapacityKey] as? Int, maximum > 0
      else { continue }
      let state = description[kIOPSPowerSourceStateKey] as? String
      return BatteryStatus(
        isOnBattery: state == kIOPSBatteryPowerValue, level: current * 100 / maximum)
    }
    return nil
  }
}
