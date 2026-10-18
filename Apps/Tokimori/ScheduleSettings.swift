import SwiftUI
import TokimoriCore

struct ScheduleSettings: View {
  @Environment(AppModel.self) private var model

  var body: some View {
    SettingsPage(
      "Keep your Mac awake during these hours on the days you pick. Changes take effect right away."
    ) {
      ForEach(model.engine.configuration.schedules) { rule in
        Section {
          ScheduleCard(rule: model.binding(\.schedules, rule)) {
            model.delete(\.schedules, rule)
          }
        }
      }
      Section {
        AddButton(title: "Add Schedule") {
          model.updateRules { $0.schedules.append(Self.newRule()) }
        }
      }
    }
  }

  private static func newRule() -> ScheduleRule {
    ScheduleRule(
      name: String(localized: "Work Hours"),
      schedule: WeeklySchedule(
        weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday],
        start: TimeOfDay(hour: 9, minute: 0), end: TimeOfDay(hour: 18, minute: 0)),
      keepsDisplayOn: false)
  }
}

private struct ScheduleCard: View {
  @Binding var rule: ScheduleRule
  let delete: () -> Void

  var body: some View {
    HStack {
      TextField("Name", text: $rule.name)
        .textFieldStyle(.plain)
        .font(Typography.rowTitle)
        .labelsHidden()
      Spacer()
      CardHeaderControls(isEnabled: $rule.isEnabled, delete: delete)
    }
    LabeledContent("Days") {
      WeekdayPicker(selection: $rule.schedule.weekdays)
    }
    LabeledContent("Time") {
      HStack(spacing: 8) {
        DatePicker(
          "From", selection: $rule.schedule.start.date, displayedComponents: .hourAndMinute
        )
        .labelsHidden()
        Text(verbatim: "–")
        DatePicker("To", selection: $rule.schedule.end.date, displayedComponents: .hourAndMinute)
          .labelsHidden()
        if rule.schedule.endsNextDay {
          Text(rule.schedule.start == rule.schedule.end ? "all day" : "next day")
            .foregroundStyle(.secondary)
        }
      }
    }
    Toggle("Keep display on", isOn: $rule.keepsDisplayOn)
      .toggleStyle(.checkbox)
  }
}
