import SettingsFeature
import SharedModels
import TestHelper
import XCTest

final class AppearanceSettingsViewSnapshotTests: XCTestCase {
  func test_appearanceEventSettingsView_light() {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettings(colorScheme: .system),
        reducer: { AppearanceSettingsFeature() }
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_appearanceEventSettingsView_disabled() {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettings(appIcon: .appIcon5, colorScheme: .dark),
        reducer: { AppearanceSettingsFeature() }
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
