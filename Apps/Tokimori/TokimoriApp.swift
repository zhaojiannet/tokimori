import SwiftUI
import TokimoriCore

@main
struct TokimoriApp: App {
  @State private var model = AppModel.shared

  var body: some Scene {
    MenuBarExtra {
      MenuContent()
        .environment(model)
    } label: {
      MenuBarLabel()
        .environment(model)
    }
    .menuBarExtraStyle(.window)

    Settings {
      SettingsView()
        .environment(model)
    }
  }
}

struct MenuBarLabel: View {
  @Environment(AppModel.self) private var model
  @AppStorage("showsRemainingTime") private var showsRemainingTime = false

  var body: some View {
    let state = model.engine.state
    // 菜单栏标签里放 TimelineView 会让状态栏图标整个消失，沙漏和剩余时间靠 model.now 定期刷新
    HStack(spacing: 4) {
      Image(
        nsImage: model.flipDegrees.map { Hourglass.flipping(pointSize: 16, degrees: $0) }
          ?? Hourglass.image(
            pointSize: 16, progress: state.preventsSleep ? Hourglass.progress(at: model.now) : nil)
      )
      if showsRemainingTime, let end = state.latestEnd {
        Text(verbatim: Format.remaining(until: end, from: model.now))
          .monospacedDigit()
      }
    }
  }
}
