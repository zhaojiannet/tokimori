import Foundation
import TokimoriPlatform

public enum ProcessMatcher {
  public static func matches(
    _ target: ProcessTarget, processes: [ProcessEntry], runningApps: Set<String>
  ) -> Bool {
    switch target {
    case .app(let app):
      return runningApps.contains(app.bundleID)
    case .process(let pattern, let matchesCommandLine):
      let needle = pattern.trimmingCharacters(in: .whitespaces)
      guard !needle.isEmpty else { return false }
      return processes.contains { process in
        if matchesCommandLine {
          return process.commandLine?.localizedCaseInsensitiveContains(needle) ?? false
        }
        return process.name.caseInsensitiveCompare(needle) == .orderedSame
      }
    }
  }
}
