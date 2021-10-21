import ComposableArchitecture
import Helpers
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

// MARK: Action
public enum AppearanceSettingsAction: Equatable {
  case setColorScheme(AppearanceSettings.ColorScheme)
  case setAppIcon(AppIcon?)
}

// MARK: Environment
public struct AppearanceSettingsEnvironment {
  public var setUserInterfaceStyle: (UIUserInterfaceStyle) -> Effect<Never, Never>
  public var uiApplicationClient: UIApplicationClient
  
  public init(
    uiApplicationClient: UIApplicationClient,
    setUserInterfaceStyle: @escaping (UIUserInterfaceStyle) -> Effect<Never, Never>
  ) {
    self.uiApplicationClient = uiApplicationClient
    self.setUserInterfaceStyle = setUserInterfaceStyle
  }
}

// MARK: Reducer
public let appearanceSettingsReducer = Reducer<AppearanceSettings, AppearanceSettingsAction, AppearanceSettingsEnvironment> { state, action, environment in
  switch action {
  case let .setColorScheme(scheme):
    state.colorScheme = scheme
    return environment.setUserInterfaceStyle(state.colorScheme.userInterfaceStyle)
      .fireAndForget()
    
  case let .setAppIcon(appIcon):
    state.appIcon = appIcon
    return environment.uiApplicationClient.setAlternateIconName(appIcon?.rawValue)
      .fireAndForget()
  }
}
