import SwiftUI
import TokimoriCore

struct AppRuleSettings: View {
  @Environment(AppModel.self) private var model

  var body: some View {
    let rules = model.engine.configuration.appRules
    SettingsPage(
      "Open or quit an app at set times. If your Mac is asleep at that moment, the action still runs when it wakes within 10 minutes; otherwise it’s skipped."
    ) {
      ForEach(rules) { rule in
        Section {
          AppRuleCard(rule: binding(rule), conflict: Self.blocker(of: rule, in: rules)) {
            model.delete(\.appRules, rule)
          }
        }
      }
      Section {
        Menu {
          AppMenuItems { app in
            model.updateRules { $0.appRules.append(Self.newRule(for: app, existing: $0.appRules)) }
          }
        } label: {
          Label("Add Timer", systemImage: "plus.circle.fill")
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
        .font(Typography.itemTitle)
      }
    }
  }

  // 和别的定时器冲突时这条自动关掉，免得同一分钟里既打开又退出
  private func binding(_ rule: AppRule) -> Binding<AppRule> {
    let base = model.binding(\.appRules, rule)
    return Binding(
      get: { base.wrappedValue },
      set: { base.wrappedValue = Self.withoutConflict($0, in: model.engine.configuration.appRules) }
    )
  }

  private static func withoutConflict(_ rule: AppRule, in rules: [AppRule]) -> AppRule {
    var rule = rule
    if rule.isEnabled, rule.conflict(in: rules.filter(\.isEnabled)) != nil {
      rule.isEnabled = false
    }
    return rule
  }

  // 只有关着的那条需要说明为什么开不了
  private static func blocker(of rule: AppRule, in rules: [AppRule]) -> AppRule? {
    rule.isEnabled ? nil : rule.conflict(in: rules.filter(\.isEnabled))
  }

  // 同一个 App 已经有「打开」时再加一条，多半是想给它配一个下班时的「退出」
  private static func newRule(for app: AppReference, existing: [AppRule]) -> AppRule {
    let opens = existing.contains { $0.app.bundleID == app.bundleID && $0.action == .launch }
    let rule = AppRule(
      app: app,
      time: WeeklyTime(
        weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday],
        time: TimeOfDay(hour: opens ? 18 : 9, minute: 0)),
      action: opens ? .quit : .launch)
    return withoutConflict(rule, in: existing)
  }
}

private struct AppRuleCard: View {
  @Binding var rule: AppRule
  let conflict: AppRule?
  let delete: () -> Void

  var body: some View {
    HStack {
      AppTitle(app: rule.app)
      Spacer()
      CardHeaderControls(isEnabled: $rule.isEnabled, delete: delete)
    }
    LabeledContent("Action") {
      HStack(spacing: 12) {
        Picker("Action", selection: $rule.action) {
          Text("Open").tag(AppAction.launch)
          Text("Quit").tag(AppAction.quit)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .fixedSize()
        DatePicker("Time", selection: $rule.time.time.date, displayedComponents: .hourAndMinute)
          .labelsHidden()
      }
    }
    LabeledContent("Days") {
      WeekdayPicker(selection: $rule.time.weekdays)
    }
    if rule.action == .quit {
      Picker("If it hasn’t quit after 30 seconds", selection: $rule.quitFallback) {
        Text("Notify me").tag(QuitFallback.notify)
        Text("Force quit").tag(QuitFallback.forceQuit)
      }
      if rule.quitFallback == .forceQuit {
        Label("Unsaved changes in the app will be lost.", systemImage: "exclamationmark.triangle")
          .font(Typography.detail)
          .foregroundStyle(.orange)
      }
    }
    if let conflict {
      let days = Format.weekdays(conflict.time.weekdays.intersection(rule.time.weekdays))
      Label(
        conflict.action == .launch
          ? "Can’t turn on: another timer opens \(conflict.app.name) at the same time on \(days)."
          : "Can’t turn on: another timer quits \(conflict.app.name) at the same time on \(days).",
        systemImage: "exclamationmark.octagon"
      )
      .font(Typography.detail)
      .foregroundStyle(.red)
    }
  }
}
