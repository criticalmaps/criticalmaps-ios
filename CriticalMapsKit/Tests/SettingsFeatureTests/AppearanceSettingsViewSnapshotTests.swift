import Foundation
import SettingsFeature
import SharedModels
import TestHelper
import Testing

@MainActor
@Suite("AppearanceSettingsView 📸 Tests", .tags(.snapshot))
struct AppearanceSettingsViewSnapshotTests {
  @Test
  func appearanceEventSettingsView_light() throws {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettingsFeature.State(colorScheme: .system),
        reducer: { AppearanceSettingsFeature() }
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  @Test
  func appearanceEventSettingsView_disabled() throws {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettingsFeature.State(
          appIcon: .sun,
          colorScheme: .system
        ),
        reducer: { AppearanceSettingsFeature() }
      )
    )
    
    try SnapshotHelper.assertScreenSnapshot(settingsView, sloppy: true)
  }
}
