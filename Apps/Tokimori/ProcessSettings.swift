import SwiftUI
import TokimoriCore

struct ProcessSettings: View {
  @Environment(AppModel.self) private var model
  @FocusState private var focused: UUID?

  var body: some View {
    SettingsPage(
      "Keep your Mac awake while an app or a command-line process is running, such as a long build, an export or an AI agent."
    ) {
      ForEach(model.engine.configuration.processRules) { rule in
        Section {
          ProcessCard(rule: model.binding(\.processRules, rule), focused: $focused) {
            model.delete(\.processRules, rule)
          }
        }
      }
      Section {
        Menu {
          AppMenuItems { app in add(.app(app)) }
          Divider()
          Button("Command-Line Process…") {
            let rule = add(.process(pattern: "", matchesCommandLine: false))
            focused = rule.id
          }
        } label: {
          Label("Add", systemImage: "plus.circle.fill")
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
        .font(Typography.itemTitle)
      }
    }
  }

  @discardableResult
  private func add(_ target: ProcessTarget) -> ProcessRule {
    let rule = ProcessRule(target: target, keepsDisplayOn: false)
    model.updateRules { $0.processRules.append(rule) }
    return rule
  }
}

private struct ProcessCard: View {
  @Binding var rule: ProcessRule
  var focused: FocusState<UUID?>.Binding
  let delete: () -> Void

  var body: some View {
    HStack {
      switch rule.target {
      case .app(let app):
        AppTitle(app: app)
      case .process(let pattern, let matchesCommandLine):
        Image(systemName: "terminal")
          .font(.title2)
          .foregroundStyle(.secondary)
          .frame(width: 28)
        TextField(
          "Pattern",
          text: Binding(
            get: { pattern },
            set: { rule.target = .process(pattern: $0, matchesCommandLine: matchesCommandLine) }),
          prompt: Text(
            matchesCommandLine
              ? "Text in the command line, such as claude" : "Process name, such as ffmpeg")
        )
        .textFieldStyle(.plain)
        .labelsHidden()
        .font(Typography.rowTitle.monospaced())
        .focused(focused, equals: rule.id)
      }
      Spacer()
      CardHeaderControls(isEnabled: $rule.isEnabled, delete: delete)
    }
    if case .process(let pattern, let matchesCommandLine) = rule.target {
      Picker(
        "Match",
        selection: Binding(
          get: { matchesCommandLine },
          set: { rule.target = .process(pattern: pattern, matchesCommandLine: $0) })
      ) {
        Text("Process name is").tag(false)
        Text("Command line contains").tag(true)
      }
      Explanation(
        matchesCommandLine
          ? "For tools that run inside node or python. Only processes started by you are checked."
          : "The name of the executable. Letter case doesn’t matter.")
    }
    Toggle("Keep display on", isOn: $rule.keepsDisplayOn)
      .toggleStyle(.checkbox)
  }
}
