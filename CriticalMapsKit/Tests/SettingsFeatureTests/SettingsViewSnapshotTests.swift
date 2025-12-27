import ComposableArchitecture
import SettingsFeature
import Styleguide
import SwiftUI
import TestHelper
import XCTest

final class SettingsViewSnapshotTests: XCTestCase {
  @MainActor
  func test_settingsView_light() {
    let settingsView = SettingsView(
      store: StoreOf<SettingsFeature>(
        initialState: SettingsFeature.State(),
        reducer: { SettingsFeature() }
      )
    )
    .environment(\.colorScheme, .light)
    .accentColor(.textPrimary)

    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
