import Foundation
import TokimoriPlatform

@testable import TokimoriCore

@MainActor
final class FakeAssertions: PowerAssertions {
  var preventsSleep = false
  var keepsDisplayOn = false

  func update(preventsSleep: Bool, keepsDisplayOn: Bool) {
    self.preventsSleep = preventsSleep
    self.keepsDisplayOn = keepsDisplayOn
  }
}

@MainActor
final class FakeApps: AppControl {
  var running: Set<String> = []
  var launchSucceeds = true
  // false 模拟弹出保存框不肯退出的 App
  var quitsWhenAsked = true
  var launched: [String] = []
  var terminated: [String] = []
  var forceTerminated: [String] = []

  func runningBundleIDs() -> Set<String> { running }

  func launch(bundleID: String, path: String) async -> Bool {
    launched.append(bundleID)
    if launchSucceeds { running.insert(bundleID) }
    return launchSucceeds
  }

  func terminate(bundleID: String) -> Bool {
    terminated.append(bundleID)
    if quitsWhenAsked { running.remove(bundleID) }
    return running.contains(bundleID) || quitsWhenAsked
  }

  func forceTerminate(bundleID: String) -> Bool {
    forceTerminated.append(bundleID)
    running.remove(bundleID)
    return true
  }
}

final class FakePower: PowerSourceReading, @unchecked Sendable {
  var battery: BatteryStatus?

  func status() -> BatteryStatus? { battery }
}

final class FakeProcesses: ProcessListing, @unchecked Sendable {
  var entries: [ProcessEntry] = []

  func processes(includingCommandLines: Bool) -> [ProcessEntry] {
    includingCommandLines ? entries : entries.map { ProcessEntry(name: $0.name, commandLine: nil) }
  }
}
