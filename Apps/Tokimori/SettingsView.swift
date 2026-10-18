import AppKit
import SwiftUI
import TokimoriCore

enum SettingsPane: String, CaseIterable {
  case general, schedules, running, timers
}

struct SettingsView: View {
  @AppStorage("settingsPane") private var pane = SettingsPane.general

  var body: some View {
    VStack(spacing: 0) {
      PaneBar(selection: $pane)
        .padding(.vertical, 10)
      Divider()
      Group {
        switch pane {
        case .general: GeneralSettings()
        case .schedules: ScheduleSettings()
        case .running: ProcessSettings()
        case .timers: AppRuleSettings()
        }
      }
      .frame(maxHeight: .infinity)
    }
    .frame(width: 660, height: 620)
  }
}

// CUSTOM: 系统分段控件在 macOS 上只显示图标或只显示文字，做不到「图标在左、文字在右」；
// 系统标签栏是上图下文，比一行多占一倍高度
private struct PaneBar: View {
  @Binding var selection: SettingsPane

  var body: some View {
    HStack(spacing: 4) {
      item(.general, "General", "gearshape")
      item(.schedules, "Schedules", "calendar")
      item(.running, "While Running", "play.circle")
      item(.timers, "App Timers", "app.badge")
    }
  }

  private func item(_ pane: SettingsPane, _ title: LocalizedStringKey, _ symbol: String)
    -> some View
  {
    let selected = selection == pane
    return Button {
      selection = pane
    } label: {
      Label(title, systemImage: symbol)
        .font(Typography.itemTitle.weight(selected ? .semibold : .regular))
        .foregroundStyle(selected ? Color.accentColor : Color.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
          selected ? Color.accentColor.opacity(0.15) : Color.clear, in: .rect(cornerRadius: 8)
        )
        .contentShape(.rect)
    }
    .buttonStyle(.plain)
  }
}

private struct GeneralSettings: View {
  @Environment(AppModel.self) private var model
  @AppStorage("showsRemainingTime") private var showsRemainingTime = false
  @State private var opensAtLogin = false

  var body: some View {
    let protection = model.engine.configuration.batteryProtection
    Form {
      Section {
        Toggle("Open at login", isOn: $opensAtLogin)
          .onChange(of: opensAtLogin) { _, on in
            guard on != model.opensAtLogin else { return }
            model.setOpensAtLogin(on)
            opensAtLogin = model.opensAtLogin
          }
        Toggle("Show time remaining in the menu bar", isOn: $showsRemainingTime)
      } footer: {
        VStack(alignment: .leading, spacing: 4) {
          Explanation("Rules only run while Tokimori is open.")
          if opensAtLogin, model.loginItemNeedsApproval {
            Explanation(
              "Allow Tokimori in System Settings › General › Login Items to finish turning this on."
            )
          }
        }
      }
      Section {
        Toggle(
          "Stop when the battery is low",
          isOn: Binding(
            get: { protection.isEnabled },
            set: { on in model.updateRules { $0.batteryProtection.isEnabled = on } }))
        Picker(
          "Battery level",
          selection: Binding(
            get: { protection.threshold },
            set: { value in model.updateRules { $0.batteryProtection.threshold = value } })
        ) {
          ForEach(Array(stride(from: 5, through: 50, by: 5)), id: \.self) { level in
            Text("Below \(level)%").tag(level)
          }
        }
        .disabled(!protection.isEnabled)
      } header: {
        Text("Battery")
      } footer: {
        Explanation(
          "Only applies when running on battery. Schedules and running-app rules resume once you plug in or the battery recovers; turning it on yourself doesn’t."
        )
      }
      Section {
        LanguagePicker()
      }
      Section {
        LabeledContent("Version") {
          Text(
            verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
              as? String ?? "")
        }
        HStack {
          Button("Check for Updates…") { Task { await UpdateChecker.check() } }
          Button("About Tokimori") { AboutPanel.show() }
        }
      } footer: {
        Explanation("Tokimori connects to the internet only when you click Check for Updates.")
      }
    }
    .formStyle(.grouped)
    .onAppear { opensAtLogin = model.opensAtLogin }
  }
}

struct LanguagePicker: View {
  @State private var selection = AppLanguage.chosen
  private let launched = AppLanguage.chosen

  var body: some View {
    Picker("Language", selection: $selection) {
      Text("Follow System").tag("")
      Divider()
      ForEach(AppLanguage.all, id: \.code) { language in
        Text(verbatim: language.name).tag(language.code)
      }
    }
    .onChange(of: selection) { _, code in AppLanguage.choose(code) }
    if selection != launched {
      HStack {
        Text("Relaunch Tokimori to use the new language.")
          .font(.callout).foregroundStyle(.secondary)
        Spacer()
        Button("Relaunch Now", action: AppLanguage.relaunch)
      }
    }
  }
}

// 界面语言写进本 App 自己的 AppleLanguages，系统在启动时据此选用语言包；菜单栏和系统对话框
// 也跟着变，所以要重新打开才完整生效
enum AppLanguage {
  static let all: [(code: String, name: String)] = [
    ("en", "English"), ("zh-Hans", "简体中文"), ("zh-Hant", "繁體中文"), ("ja", "日本語"),
    ("ko", "한국어"), ("de", "Deutsch"), ("fr", "Français"), ("es", "Español"),
    ("pt", "Português"), ("id", "Bahasa Indonesia"), ("th", "ไทย"), ("vi", "Tiếng Việt"),
    ("ar", "العربية"), ("ru", "Русский"), ("hi", "हिन्दी"),
  ]

  private static let key = "AppleLanguages"

  // 只读本 App 自己的设置；UserDefaults.standard 会把系统全局的语言列表也带进来
  static var chosen: String {
    guard let id = Bundle.main.bundleIdentifier,
      let languages = UserDefaults.standard.persistentDomain(forName: id)?[key] as? [String]
    else { return "" }
    return languages.first ?? ""
  }

  static func choose(_ code: String) {
    if code.isEmpty {
      UserDefaults.standard.removeObject(forKey: key)
    } else {
      UserDefaults.standard.set([code], forKey: key)
    }
  }

  static func relaunch() {
    let configuration = NSWorkspace.OpenConfiguration()
    configuration.createsNewApplicationInstance = true
    NSWorkspace.shared.openApplication(at: Bundle.main.bundleURL, configuration: configuration) {
      _, _ in
      DispatchQueue.main.async { NSApp.terminate(nil) }
    }
  }
}
