import SwiftUI
import TokimoriCore
import TokimoriPlatform

struct MenuContent: View {
  @Environment(AppModel.self) private var model
  @Environment(\.openSettings) private var openSettings
  @AppStorage("keepsDisplayOn") private var keepsDisplayOn = false
  @State private var choosingTime = false
  @State private var untilTime = Date.now.addingTimeInterval(3600)

  private let durations: [Duration] = [
    .seconds(30 * 60), .seconds(3600), .seconds(2 * 3600), .seconds(4 * 3600),
  ]

  var body: some View {
    let state = model.engine.state
    VStack(alignment: .leading, spacing: 16) {
      header(state)

      if !state.sources.isEmpty {
        VStack(alignment: .leading, spacing: 6) {
          ForEach(state.sources, id: \.self) { source in
            SourceRow(source: source)
          }
        }
      }

      VStack(alignment: .leading, spacing: 8) {
        Text("Keep awake for").font(Typography.subheader).foregroundStyle(.secondary)
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
          GridRow {
            durationButton(Text("Indefinitely")) { model.start(for: nil) }
            durationButton(Text(verbatim: Format.duration(durations[0]))) {
              model.start(for: durations[0])
            }
            durationButton(Text(verbatim: Format.duration(durations[1]))) {
              model.start(for: durations[1])
            }
          }
          GridRow {
            durationButton(Text(verbatim: Format.duration(durations[2]))) {
              model.start(for: durations[2])
            }
            durationButton(Text(verbatim: Format.duration(durations[3]))) {
              model.start(for: durations[3])
            }
            durationButton(Text("Until…")) { choosingTime.toggle() }
              .popover(isPresented: $choosingTime, arrowEdge: .bottom) { untilPicker }
          }
        }
        .disabled(state.isBlockedByBattery)
      }

      HStack {
        // 快捷指令开启时可能带了不同的屏幕设置，有手动会话时以它为准
        Toggle(
          "Keep display on",
          isOn: Binding(
            get: { model.engine.manual?.keepsDisplayOn ?? keepsDisplayOn },
            set: { on in
              keepsDisplayOn = on
              model.setKeepsDisplayOn(on)
            }))
        Spacer()
        Button {
          DisplaySleep.now()
        } label: {
          Label("Turn Display Off", systemImage: "moon.zzz")
        }
        .help(Text("Turns the display off now while your Mac keeps running."))
      }
      .font(Typography.itemTitle)

      if let next = model.engine.nextAppAction {
        Label {
          Text(nextActionText(next))
        } icon: {
          Image(systemName: "clock")
        }
        .font(Typography.detail)
        .foregroundStyle(.secondary)
      }

      Divider()
      HStack {
        Button {
          NSApp.activate()
          openSettings()
        } label: {
          Label("Settings…", systemImage: "gearshape")
        }
        Spacer()
        Button {
          model.quit()
        } label: {
          Label("Quit Tokimori", systemImage: "power")
        }
      }
      .buttonStyle(.borderless)
      .font(Typography.itemTitle)
    }
    .padding(18)
    .frame(width: 340)
  }

  private func header(_ state: AwakeState) -> some View {
    HStack(spacing: 14) {
      Image(
        nsImage: Hourglass.image(
          pointSize: 28, progress: state.preventsSleep ? Hourglass.progress(at: model.now) : nil)
      )
      .renderingMode(.template)
      .foregroundStyle(state.preventsSleep ? Color.accentColor : Color.secondary)
      VStack(alignment: .leading, spacing: 2) {
        Text("Keep Awake").font(Typography.sectionTitle)
        Text(summary(state))
          .font(Typography.detail)
          .foregroundStyle(.secondary)
      }
      Spacer()
      Toggle(
        "Keep Awake",
        isOn: Binding(
          get: { state.preventsSleep },
          set: { $0 ? model.start(for: nil) : model.turnOff() })
      )
      .toggleStyle(.switch)
      .labelsHidden()
      .controlSize(.large)
      .disabled(state.isBlockedByBattery)
    }
  }

  private func summary(_ state: AwakeState) -> String {
    if state.isBlockedByBattery {
      let threshold = model.engine.configuration.batteryProtection.threshold
      return String(localized: "Paused: battery below \(threshold)%")
    }
    guard state.preventsSleep else { return String(localized: "Your Mac can sleep as usual.") }
    guard let end = state.latestEnd else { return String(localized: "Until you turn it off") }
    return String(localized: "Until \(Format.dayAndTime(end))")
  }

  private func durationButton(_ title: Text, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      title.frame(maxWidth: .infinity)
    }
    .controlSize(.large)
  }

  private var untilPicker: some View {
    VStack(alignment: .trailing, spacing: 12) {
      DatePicker("Until", selection: $untilTime, displayedComponents: .hourAndMinute)
        .datePickerStyle(.field)
        .font(Typography.itemTitle)
      Button("Start") {
        choosingTime = false
        model.start(untilTimeOfDay: untilTime)
      }
      .keyboardShortcut(.defaultAction)
      .controlSize(.large)
    }
    .padding(16)
  }

  private func nextActionText(_ next: ScheduledAppAction) -> String {
    let when = Format.dayAndTime(next.date)
    let name = next.rule.app.name
    switch next.rule.action {
    case .launch: return String(localized: "Next: open \(name) \(when)")
    case .quit: return String(localized: "Next: quit \(name) \(when)")
    }
  }
}

private struct SourceRow: View {
  let source: AwakeSource

  var body: some View {
    Label {
      Text(text)
    } icon: {
      Image(systemName: symbol).foregroundStyle(Color.accentColor)
    }
    .font(Typography.itemTitle)
  }

  private var symbol: String {
    switch source {
    case .manual: "hand.tap"
    case .schedule: "calendar"
    case .process: "play.circle"
    }
  }

  private var text: String {
    switch source {
    case .manual(let until?):
      String(localized: "Turned on by you, until \(Format.dayAndTime(until))")
    case .manual(nil):
      String(localized: "Turned on by you, until you turn it off")
    case .schedule(_, let name, let until):
      String(localized: "Schedule “\(name)”, until \(Format.dayAndTime(until))")
    case .process(_, let name):
      String(localized: "While \(name) is running")
    }
  }
}
