import SettingsFeature
import Styleguide
import SwiftUI
import TestHelper
import XCTest

final class SettingsViewSnapshotTests: XCTestCase {
  @MainActor
  func test_settingsView_light() {
    let settingsView = SettingsView(
      store: .init(
        initialState: .init(),
        reducer: { SettingsFeature() },
        withDependencies: {
          $0.uiApplicationClient.alternateIconName = { nil }
        }
      )
    )
    .environment(\.colorScheme, .light)
    .accentColor(.textPrimary)

    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
