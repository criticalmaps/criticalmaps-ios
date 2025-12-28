import ComposableArchitecture
import SettingsFeature
import Styleguide
import SwiftUI
import TestHelper
import XCTest

@MainActor
final class SettingsViewSnapshotTests: XCTestCase {
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
