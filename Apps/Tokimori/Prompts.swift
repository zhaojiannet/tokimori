import AppKit
import TokimoriCore

// 菜单栏 App 没有自己的窗口，弹框前先把自己调到前台，否则对话框落在别的 App 后面
enum Prompts {
  static func turnOff(_ active: [(rule: ScheduleRule, interval: DateInterval)]) -> TurnOffChoice? {
    guard let end = active.map(\.interval.end).max() else { return nil }
    let names = ListFormatter.localizedString(byJoining: active.map { "“\($0.rule.name)”" })
    let time = Format.time(end)
    let alert = NSAlert()
    alert.messageText =
      active.count == 1
      ? String(localized: "The \(names) schedule is keeping your Mac awake")
      : String(localized: "The \(names) schedules are keeping your Mac awake")
    alert.informativeText = [
      String(localized: "It lasts until \(Format.dayAndTime(end))."),
      String(
        localized:
          "Stop Until \(time): stays off for the rest of this period and turns on again automatically next time."
      ),
      active.count == 1
        ? String(
          localized:
            "Turn Off This Schedule: never turns on automatically again. You can turn it back on in Settings."
        )
        : String(
          localized:
            "Turn Off These Schedules: they never turn on automatically again. You can turn them back on in Settings."
        ),
    ].joined(separator: "\n\n")
    alert.addButton(withTitle: String(localized: "Stop Until \(time)"))
    alert.addButton(
      withTitle: active.count == 1
        ? String(localized: "Turn Off This Schedule")
        : String(localized: "Turn Off These Schedules"))
    alert.addButton(withTitle: String(localized: "Stay Awake"))
    // 第三个按钮默认没有 Esc 快捷键，按 Esc 应当等于「什么都不改」
    alert.buttons[2].keyEquivalent = "\u{1b}"
    NSApp.activate()
    switch alert.runModal() {
    case .alertFirstButtonReturn: return .pauseUntilEnd
    case .alertSecondButtonReturn: return .disableRules
    default: return nil
    }
  }

  static func openAtLogin() -> Bool {
    let alert = NSAlert()
    alert.messageText = String(localized: "Open Tokimori at login?")
    alert.informativeText = String(
      localized:
        "Your rules only run while Tokimori is open. You can change this later in Settings.")
    alert.addButton(withTitle: String(localized: "Open at Login"))
    alert.addButton(withTitle: String(localized: "Not Now"))
    NSApp.activate()
    return alert.runModal() == .alertFirstButtonReturn
  }

  static func confirmQuit() -> Bool {
    let alert = NSAlert()
    alert.messageText = String(localized: "Quit Tokimori?")
    alert.informativeText = String(
      localized:
        "Your rules won’t run while Tokimori is closed, and your Mac can go to sleep again.")
    alert.addButton(withTitle: String(localized: "Quit"))
    alert.addButton(withTitle: String(localized: "Cancel"))
    alert.showsSuppressionButton = true
    alert.suppressionButton?.title = String(localized: "Don’t ask again")
    NSApp.activate()
    let confirmed = alert.runModal() == .alertFirstButtonReturn
    if confirmed, alert.suppressionButton?.state == .on { Preferences.suppressQuitWarning = true }
    return confirmed
  }

  static func loginItemFailed(_ error: any Error) {
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = String(localized: "Couldn’t change the login item")
    alert.informativeText = error.localizedDescription
    NSApp.activate()
    alert.runModal()
  }
}
