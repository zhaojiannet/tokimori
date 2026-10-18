import AppIntents
import TokimoriCore

struct KeepAwakeIntent: AppIntent {
  static let title: LocalizedStringResource = "Keep Mac Awake"
  static let description = IntentDescription(
    "Keeps your Mac from sleeping. Leave both Minutes and Until empty to keep it awake until you turn it off."
  )

  @Parameter(title: "Minutes", inclusiveRange: (1, 1440))
  var minutes: Int?

  @Parameter(title: "Until")
  var until: Date?

  @Parameter(title: "Keep Display On", default: false)
  var keepsDisplayOn: Bool

  static var parameterSummary: some ParameterSummary {
    Summary("Keep Mac awake for \(\.$minutes) minutes or until \(\.$until)") {
      \.$keepsDisplayOn
    }
  }

  @MainActor
  func perform() async throws -> some IntentResult {
    let end = minutes.map { Date.now.addingTimeInterval(TimeInterval($0 * 60)) } ?? until
    if let end, end <= .now { throw ShortcutError.endHasPassed }
    let model = AppModel.shared
    guard model.start(until: end, keepsDisplayOn: keepsDisplayOn) else {
      throw ShortcutError.batteryLow(
        threshold: model.engine.configuration.batteryProtection.threshold)
    }
    return .result()
  }
}

// 自动化里静默失败会让人以为 Mac 一直醒着，开不起来时要报错
enum ShortcutError: Error, CustomLocalizedStringResourceConvertible {
  case endHasPassed
  case batteryLow(threshold: Int)

  var localizedStringResource: LocalizedStringResource {
    switch self {
    case .endHasPassed:
      "That time has already passed."
    case .batteryLow(let threshold):
      "Tokimori doesn’t keep your Mac awake while the battery is below \(threshold)%."
    }
  }
}

struct StopKeepingAwakeIntent: AppIntent {
  static let title: LocalizedStringResource = "Stop Keeping Mac Awake"
  static let description = IntentDescription(
    "Lets your Mac sleep again. Active schedules stay off until their current period ends.")

  @MainActor
  func perform() async throws -> some IntentResult {
    AppModel.shared.turnOffWithoutAsking()
    return .result()
  }
}

struct IsKeepingAwakeIntent: AppIntent {
  static let title: LocalizedStringResource = "Is Mac Being Kept Awake"
  static let description = IntentDescription("Returns whether Tokimori is keeping your Mac awake.")

  @MainActor
  func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
    .result(value: AppModel.shared.engine.state.preventsSleep)
  }
}
