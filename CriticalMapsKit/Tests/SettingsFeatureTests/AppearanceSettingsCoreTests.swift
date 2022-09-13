import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

@MainActor
final class AppearanceSettingsCoreTests: XCTestCase {
  
  func test_selectAppIcon_shouldUpdateState() async {
    var overriddenIconName: String!
    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: AppearanceSettingsFeature()
    )
    store.dependencies.uiApplicationClient.setAlternateIconName = { newValue in
      .fireAndForget {
        overriddenIconName = newValue
      }
    }
    
    await store.send(.set(\.$appIcon, .appIcon4)) { state in
      state.appIcon = .appIcon4
    }
    XCTAssertNoDifference(overriddenIconName, "appIcon-4")
  }

  func testSetColorScheme() async {
    var overriddenUserInterfaceStyle: UIUserInterfaceStyle!

    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: AppearanceSettingsFeature()
    )
    store.dependencies.setUserInterfaceStyle = { newValue in
      .fireAndForget {
        overriddenUserInterfaceStyle = newValue
      }
    }
    
    await store.send(.set(\.$colorScheme, .light)) {
      $0.colorScheme = .light
    }
    XCTAssertNoDifference(overriddenUserInterfaceStyle, .light)

    await store.send(.set(\.$colorScheme, .system)) {
      $0.colorScheme = .system
    }
    XCTAssertNoDifference(overriddenUserInterfaceStyle, .unspecified)
  }
}
