import ComposableArchitecture
import Foundation
@testable import SettingsFeature
import SharedModels
import Testing
import UIKit

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
        $0.uiApplicationClient.setAlternateIconName = { newValue in
          overriddenIconName.setValue(newValue)
        }
      }
    )

    await store.send(.binding(.set(\.appIcon, .rainbow))) { state in
      state.appIcon = .rainbow
      state.$settings.withLock { $0.appIcon = .rainbow }
    }
    overriddenIconName.withValue { iconName in
      #expect(iconName == "AppIcon-Rainbow")
    }
  }

  @Test("Set Color scheme should update state")
  func setColorScheme() async {
    let overriddenUserInterfaceStyle = LockIsolated(UIUserInterfaceStyle.unspecified)

    let store = TestStore(
      initialState: AppearanceSettingsFeature.State(),
      reducer: { AppearanceSettingsFeature() },
      withDependencies: {
        $0.uiApplicationClient.setUserInterfaceStyle = { newValue in
          overriddenUserInterfaceStyle.setValue(newValue)
          return ()
        }
      }
    )

    await store.send(.binding(.set(\.colorScheme, .light))) {
      $0.colorScheme = .light
      $0.$settings.withLock { $0.colorScheme = .light }
    }
    overriddenUserInterfaceStyle.withValue { style in
      expectNoDifference(style, .light)
    }

    await store.send(.binding(.set(\.colorScheme, .system))) {
      $0.colorScheme = .system
      $0.$settings.withLock { $0.colorScheme = .system }
    }
    overriddenUserInterfaceStyle.withValue { style in
      expectNoDifference(style, .unspecified)
    }
  }
}
