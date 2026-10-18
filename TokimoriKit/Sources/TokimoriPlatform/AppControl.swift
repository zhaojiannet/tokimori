import AppKit

@MainActor
public protocol AppControl: AnyObject {
  func runningBundleIDs() -> Set<String>
  func launch(bundleID: String, path: String) async -> Bool
  // 返回请求是否发出去了；App 可能弹保存框而不退出，要另外检查
  func terminate(bundleID: String) -> Bool
  func forceTerminate(bundleID: String) -> Bool
}

// 沙盒 App 调 terminate、forceTerminate 一律返回 false，这是本 App 不开沙盒的原因
@MainActor
public final class WorkspaceAppControl: AppControl {
  public init() {}

  public func runningBundleIDs() -> Set<String> {
    Set(NSWorkspace.shared.runningApplications.compactMap(\.bundleIdentifier))
  }

  public func launch(bundleID: String, path: String) async -> Bool {
    let fallback = URL(filePath: path)
    guard
      let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID)
        ?? (FileManager.default.fileExists(atPath: path) ? fallback : nil)
    else { return false }
    do {
      _ = try await NSWorkspace.shared.openApplication(
        at: url, configuration: NSWorkspace.OpenConfiguration())
      return true
    } catch {
      return false
    }
  }

  public func terminate(bundleID: String) -> Bool {
    instances(bundleID).reduce(false) { $1.terminate() || $0 }
  }

  public func forceTerminate(bundleID: String) -> Bool {
    instances(bundleID).reduce(false) { $1.forceTerminate() || $0 }
  }

  private func instances(_ bundleID: String) -> [NSRunningApplication] {
    NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
  }
}
