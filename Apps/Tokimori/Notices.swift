import OSLog
import TokimoriCore
import UserNotifications

// 只在出问题时发通知，第一次要发的时候才申请权限
enum Notices {
  private static let logger = Logger(subsystem: "net.zhaojian.tokimori", category: "notices")

  static func post(_ event: EngineEvent) {
    let content = UNMutableNotificationContent()
    switch event {
    case .launchFailed(let name):
      content.title = String(localized: "Couldn’t open \(name)")
      content.body = String(localized: "The app may have been moved or deleted.")
    case .quitFailed(let name):
      content.title = String(localized: "\(name) didn’t quit")
      content.body = String(localized: "It may be waiting for you to save changes.")
    case .batteryStopped(let threshold):
      content.title = String(localized: "Stopped keeping your Mac awake")
      content.body = String(localized: "The battery is below \(threshold)%.")
    }
    Task {
      let center = UNUserNotificationCenter.current()
      do {
        guard try await center.requestAuthorization(options: [.alert, .sound]) else { return }
        try await center.add(
          UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil))
      } catch {
        logger.error("notification failed: \(error.localizedDescription, privacy: .public)")
      }
    }
  }
}
