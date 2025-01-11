import SettingsFeature
import SharedModels
import TestHelper
import XCTest

final class AppearanceSettingsViewSnapshotTests: XCTestCase {
  func test_appearanceEventSettingsView_light() {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettingsFeature.State(colorScheme: .system),
        reducer: { AppearanceSettingsFeature() }
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_appearanceEventSettingsView_disabled() {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettingsFeature.State(
          appIcon: .appIcon5,
          colorScheme: .system
        ),
        reducer: { AppearanceSettingsFeature() }
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
