import Foundation
import IOKit.pwr_mgt

@MainActor
public protocol PowerAssertions: AnyObject {
  func update(preventsSleep: Bool, keepsDisplayOn: Bool)
}

// 断言跟着进程走：进程退出或崩溃时系统自动释放，不会留下一直不睡的 Mac
@MainActor
public final class IOKitPowerAssertions: PowerAssertions {
  private let name: String
  private var system: IOPMAssertionID?
  private var display: IOPMAssertionID?

  public init(name: String) {
    self.name = name
  }

  public func update(preventsSleep: Bool, keepsDisplayOn: Bool) {
    // PreventUserIdleSystemSleep 只拦系统睡眠，屏幕照常熄灭；屏幕常亮另加一个显示器断言
    set(&system, type: kIOPMAssertPreventUserIdleSystemSleep, on: preventsSleep)
    set(&display, type: kIOPMAssertPreventUserIdleDisplaySleep, on: preventsSleep && keepsDisplayOn)
  }

  private func set(_ assertion: inout IOPMAssertionID?, type: String, on: Bool) {
    if on, assertion == nil {
      var id = IOPMAssertionID(0)
      let result = IOPMAssertionCreateWithName(
        type as CFString, IOPMAssertionLevel(kIOPMAssertionLevelOn), name as CFString, &id)
      if result == kIOReturnSuccess { assertion = id }
    } else if !on, let id = assertion {
      IOPMAssertionRelease(id)
      assertion = nil
    }
  }
}

public enum DisplaySleep {
  public static func now() {
    let process = Process()
    process.executableURL = URL(filePath: "/usr/bin/pmset")
    process.arguments = ["displaysleepnow"]
    try? process.run()
  }
}
