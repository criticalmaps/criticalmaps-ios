import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

class AppearanceSettingsCoreTests: XCTestCase {
  var defaultEnvironment = AppearanceSettingsEnvironment(
    uiApplicationClient: .noop,
    setUserInterfaceStyle: { _ in .none }
  )

  func test_selectAppIcon_shouldUpdateState() {
    var overriddenIconName: String!

    var env = defaultEnvironment
    env.uiApplicationClient.setAlternateIconName = { newValue in
      .fireAndForget {
        overriddenIconName = newValue
      }
    }

    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: appearanceSettingsReducer,
      environment: env
    )
    store.send(.setAppIcon(.appIcon4)) { state in
      state.appIcon = .appIcon4
    }
    XCTAssertNoDifference(overriddenIconName, "appIcon-4")
  }

  func testSetColorScheme() {
    var overriddenUserInterfaceStyle: UIUserInterfaceStyle!

    var environment = defaultEnvironment
    environment.setUserInterfaceStyle = { newValue in
      .fireAndForget {
        overriddenUserInterfaceStyle = newValue
      }
    }

    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: appearanceSettingsReducer,
      environment: environment
    )

    store.send(.setColorScheme(.light)) {
      $0.colorScheme = .light
    }
    XCTAssertNoDifference(overriddenUserInterfaceStyle, .light)

    store.send(.setColorScheme(.system)) {
      $0.colorScheme = .system
    }
    XCTAssertNoDifference(overriddenUserInterfaceStyle, .unspecified)
  }
}
