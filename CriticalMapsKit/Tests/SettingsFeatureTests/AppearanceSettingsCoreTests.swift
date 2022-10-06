import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

@MainActor
final class AppearanceSettingsCoreTests: XCTestCase {
  func test_selectAppIcon_shouldUpdateState() async {
    let overriddenIconName = ActorIsolated<String?>(nil)
    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: AppearanceSettingsFeature()
    )
    store.dependencies.uiApplicationClient.setAlternateIconName = { newValue in
      await overriddenIconName.setValue(newValue)
    }

    await store.send(.set(\.$appIcon, .appIcon4)) { state in
      state.appIcon = .appIcon4
    }
    await overriddenIconName.withValue { iconName in
      XCTAssertNoDifference(iconName, "appIcon-4")
    }
  }

  func testSetColorScheme() async {
    let overriddenUserInterfaceStyle = ActorIsolated(UIUserInterfaceStyle.unspecified)

    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: AppearanceSettingsFeature()
    )
    store.dependencies.setUserInterfaceStyle = { newValue in
      await overriddenUserInterfaceStyle.setValue(newValue)
      return ()
    }

    await store.send(.set(\.$colorScheme, .light)) {
      $0.colorScheme = .light
    }
    await overriddenUserInterfaceStyle.withValue { stlye in
      XCTAssertNoDifference(stlye, .light)
    }

    await store.send(.set(\.$colorScheme, .system)) {
      $0.colorScheme = .system
    }
    await overriddenUserInterfaceStyle.withValue { stlye in
      XCTAssertNoDifference(stlye, .unspecified)
    }
  }
}
