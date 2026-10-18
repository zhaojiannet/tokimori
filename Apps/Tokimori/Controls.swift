import AppKit
import SwiftUI
import TokimoriCore
import UniformTypeIdentifiers

// CUSTOM: 按钮样式的 Toggle 选中和没选中只差一点底色，一眼看不出哪几天勾上了
struct WeekdayPicker: View {
  @Binding var selection: Set<Weekday>

  var body: some View {
    HStack(spacing: 4) {
      ForEach(Format.orderedWeekdays(), id: \.self) { day in
        let on = selection.contains(day)
        Button {
          if on { selection.remove(day) } else { selection.insert(day) }
        } label: {
          Text(verbatim: Format.shortName(day))
            .font(Typography.itemTitle.weight(on ? .semibold : .regular))
            .foregroundStyle(on ? Color.white : Color.primary)
            .frame(minWidth: 34, minHeight: 26)
            .background(
              on ? Color.accentColor : Color.secondary.opacity(0.15), in: .rect(cornerRadius: 6)
            )
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(on ? .isSelected : [])
      }
    }
  }
}

extension Binding where Value == TimeOfDay {
  // DatePicker 只认 Date，这里只取它的时和分
  var date: Binding<Date> {
    Binding<Date>(
      get: {
        Calendar.autoupdatingCurrent.date(
          bySettingHour: wrappedValue.hour, minute: wrappedValue.minute, second: 0, of: .now)
          ?? .now
      },
      set: { date in
        let parts = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: date)
        wrappedValue = TimeOfDay(hour: parts.hour ?? 0, minute: parts.minute ?? 0)
      })
  }
}

enum AppChooser {
  static func choose() -> AppReference? {
    let panel = NSOpenPanel()
    panel.allowedContentTypes = [.application]
    panel.directoryURL = URL(filePath: "/Applications")
    panel.allowsMultipleSelection = false
    panel.message = String(localized: "Choose an app")
    NSApp.activate()
    guard panel.runModal() == .OK, let url = panel.url else { return nil }
    return reference(for: url)
  }

  static func reference(for url: URL) -> AppReference? {
    guard let bundleID = Bundle(url: url)?.bundleIdentifier else { return nil }
    let name = (FileManager.default.displayName(atPath: url.path) as NSString)
      .deletingPathExtension
    return AppReference(bundleID: bundleID, name: name, path: url.path)
  }

  // 有 Dock 图标的 App 才列出来，后台进程和 Tokimori 自己不算
  static func running() -> [AppReference] {
    let own = Bundle.main.bundleIdentifier
    let apps = NSWorkspace.shared.runningApplications.filter {
      $0.activationPolicy == .regular && $0.bundleIdentifier != own
    }
    let references = apps.compactMap { $0.bundleURL.flatMap(reference(for:)) }
    return Dictionary(references.map { ($0.bundleID, $0) }, uniquingKeysWith: { first, _ in first })
      .values.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
  }

  static func icon(for app: AppReference, size: CGFloat) -> NSImage {
    let image = NSWorkspace.shared.icon(forFile: app.path)
    image.size = NSSize(width: size, height: size)
    return image
  }
}

// 先列正在运行的 App，一下就能点到；不在运行的再用「其他 App…」去找
struct AppMenuItems: View {
  let choose: (AppReference) -> Void

  var body: some View {
    let running = AppChooser.running()
    if !running.isEmpty {
      Section("Running Apps") {
        ForEach(running, id: \.bundleID) { app in
          Button {
            choose(app)
          } label: {
            Label {
              Text(verbatim: app.name)
            } icon: {
              Image(nsImage: AppChooser.icon(for: app, size: 16))
            }
          }
        }
      }
    }
    Button("Other App…") {
      if let app = AppChooser.choose() { choose(app) }
    }
  }
}

struct AppTitle: View {
  let app: AppReference

  var body: some View {
    HStack(spacing: 10) {
      Image(nsImage: AppChooser.icon(for: app, size: 28))
      Text(verbatim: app.name).font(Typography.rowTitle)
    }
  }
}

struct CardHeaderControls: View {
  @Binding var isEnabled: Bool
  let delete: () -> Void

  var body: some View {
    Toggle("On", isOn: $isEnabled)
      .toggleStyle(.switch)
      .labelsHidden()
      .help(Text(isEnabled ? "Turn off" : "Turn on"))
    Button(role: .destructive, action: delete) {
      Image(systemName: "trash")
    }
    .buttonStyle(.borderless)
    .help(Text("Delete"))
  }
}

struct Explanation: View {
  let text: LocalizedStringKey

  init(_ text: LocalizedStringKey) {
    self.text = text
  }

  var body: some View {
    Text(text)
      .font(Typography.detail)
      .foregroundStyle(.secondary)
      .fixedSize(horizontal: false, vertical: true)
  }
}

struct SettingsPage<Content: View>: View {
  let explanation: LocalizedStringKey
  @ViewBuilder let content: Content

  init(_ explanation: LocalizedStringKey, @ViewBuilder content: () -> Content) {
    self.explanation = explanation
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Explanation(explanation)
        .padding(.horizontal, 30)
        .padding(.top, 18)
      Form { content }
        .formStyle(.grouped)
    }
  }
}

struct AddButton: View {
  let title: LocalizedStringKey
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Label(title, systemImage: "plus.circle.fill")
    }
    .buttonStyle(.borderless)
    .font(Typography.itemTitle)
  }
}

extension AppModel {
  // 卡片上的每个控件都直接改配置，改完立即生效，没有单独的保存步骤
  func binding<Rule: Identifiable<UUID>>(
    _ list: WritableKeyPath<Configuration, [Rule]>, _ rule: Rule
  ) -> Binding<Rule> {
    Binding(
      get: { self.engine.configuration[keyPath: list].first { $0.id == rule.id } ?? rule },
      set: { new in
        self.updateRules { configuration in
          if let index = configuration[keyPath: list].firstIndex(where: { $0.id == rule.id }) {
            configuration[keyPath: list][index] = new
          }
        }
      })
  }

  func delete<Rule: Identifiable<UUID>>(
    _ list: WritableKeyPath<Configuration, [Rule]>, _ rule: Rule
  ) {
    updateRules { $0[keyPath: list].removeAll { $0.id == rule.id } }
  }
}
