import TestHelper
import XCTest
import SettingsFeature
import SharedModels

class AppearanceSettingsViewSnapshotTests: XCTestCase {
  func test_appearanceEventSettingsView_light() {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettings(colorScheme: .system),
        reducer: appearanceSettingsReducer,
        environment: .init(
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
  
  func test_appearanceEventSettingsView_disabled() {
    let settingsView = AppearanceSettingsView(
      store: .init(
        initialState: AppearanceSettings(appIcon: .appIcon5, colorScheme: .dark),
        reducer: appearanceSettingsReducer,
        environment: .init(
          uiApplicationClient: .noop,
          setUserInterfaceStyle: { _ in .none }
        )
      )
    )
    
    assertScreenSnapshot(settingsView, sloppy: true)
  }
}
