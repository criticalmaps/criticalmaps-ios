import ComposableArchitecture
import SettingsFeature
import Styleguide
import SwiftUI
import TestHelper
import XCTest

@MainActor
final class SettingsViewSnapshotTests: XCTestCase {
  func test_settingsView_light() throws {
    let settingsView = SettingsView(
      store: StoreOf<SettingsFeature>(
        initialState: SettingsFeature.State(),
        reducer: { SettingsFeature() }
      )
    )
    .environment(\.colorScheme, .light)
    .accentColor(.textPrimary)

    try assertScreenSnapshot(settingsView, sloppy: true)
  }
}
