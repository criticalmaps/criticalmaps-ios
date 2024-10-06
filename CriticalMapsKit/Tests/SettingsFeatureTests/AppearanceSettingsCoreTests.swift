import ComposableArchitecture
import Foundation
import SettingsFeature
import SharedModels
import XCTest

final class AppearanceSettingsCoreTests: XCTestCase {
  
  @MainActor
  func test_selectAppIcon_shouldUpdateState() async {
    let overriddenIconName = LockIsolated<String?>(nil)
    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: { AppearanceSettingsFeature() },
      withDependencies: {
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    store.dependencies.uiApplicationClient.setAlternateIconName = { newValue in
      overriddenIconName.setValue(newValue)
    }

    await store.send(.set(\.$appIcon, .appIcon4)) { state in
      state.appIcon = .appIcon4
    }
    overriddenIconName.withValue { iconName in
      expectNoDifference(iconName, "appIcon-4")
    }
  }

  @MainActor
  func testSetColorScheme() async {
    let overriddenUserInterfaceStyle = LockIsolated(UIUserInterfaceStyle.unspecified)

    let store = TestStore(
      initialState: AppearanceSettings(),
      reducer: { AppearanceSettingsFeature() }
    )
    store.dependencies.setUserInterfaceStyle = { newValue in
      overriddenUserInterfaceStyle.setValue(newValue)
      return ()
    }

    await store.send(.set(\.$colorScheme, .light)) {
      $0.colorScheme = .light
    }
    overriddenUserInterfaceStyle.withValue { stlye in
      expectNoDifference(stlye, .light)
    }

    await store.send(.set(\.$colorScheme, .system)) {
      $0.colorScheme = .system
    }
    overriddenUserInterfaceStyle.withValue { stlye in
      expectNoDifference(stlye, .unspecified)
    }
  }
}
