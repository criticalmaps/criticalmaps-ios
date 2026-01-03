import ComposableArchitecture
import Foundation
import SettingsFeature
import Styleguide
import SwiftUI
import TestHelper
import Testing

@MainActor
@Suite("SettingsView 📸 Tests", .tags(.snapshot))
struct SettingsViewSnapshotTests {
  @Test
  func settingsView_light() throws {
    let settingsView = SettingsView(
      store: StoreOf<SettingsFeature>(
        initialState: SettingsFeature.State(),
        reducer: { SettingsFeature() }
      )
    )

    try SnapshotHelper.assertScreenSnapshot(settingsView, sloppy: true)
  }
}
