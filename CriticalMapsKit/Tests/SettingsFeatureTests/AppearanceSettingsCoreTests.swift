import ComposableArchitecture
import UIKit
import Foundation
import SettingsFeature
import SharedModels
import Testing

@Suite
@MainActor
struct AppearanceSettingsCoreTests {
  
  @Test("Select AppIcon should update state")
  func selectAppIcon_shouldUpdateState() async {
    let overriddenIconName = LockIsolated<String?>(nil)
    let store = TestStore(
      initialState: AppearanceSettingsFeature.State(),
      reducer: { AppearanceSettingsFeature() },
      withDependencies: {
        $0.feedbackGenerator.selectionChanged = {}
      }
    )
    store.dependencies.uiApplicationClient.setAlternateIconName = { newValue in
      overriddenIconName.setValue(newValue)
    }

    await store.send(.binding(.set(\.appIcon, .appIcon4))) { state in
      state.appIcon = .appIcon4
    }
    overriddenIconName.withValue { iconName in
      #expect(iconName == "appIcon-4")
    }
  }

  @Test("Set Color scheme should update state")
  func setColorScheme() async {
    let overriddenUserInterfaceStyle = LockIsolated(UIUserInterfaceStyle.unspecified)

    let store = TestStore(
      initialState: AppearanceSettingsFeature.State(),
      reducer: { AppearanceSettingsFeature() }
    )
    store.dependencies.setUserInterfaceStyle = { newValue in
      overriddenUserInterfaceStyle.setValue(newValue)
      return ()
    }

    await store.send(.binding(.set(\.colorScheme, .light))) {
      $0.colorScheme = .light
    }
    overriddenUserInterfaceStyle.withValue { stlye in
      expectNoDifference(stlye, .light)
    }

    await store.send(.binding(.set(\.colorScheme, .system))) {
      $0.colorScheme = .system
    }
    overriddenUserInterfaceStyle.withValue { stlye in
      expectNoDifference(stlye, .unspecified)
    }
  }
}
