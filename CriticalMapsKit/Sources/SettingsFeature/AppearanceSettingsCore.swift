import ComposableArchitecture
import Helpers
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

// MARK: Action

public enum AppearanceSettingsAction: Equatable, BindableAction {
  case binding(BindingAction<AppearanceSettings>)
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

public typealias AppearanceReducer = Reducer<AppearanceSettings, AppearanceSettingsAction, AppearanceSettingsEnvironment>
/// Reducer to handle appearance settings actions 
public let appearanceSettingsReducer = AppearanceReducer { state, action, environment in
  switch action {
  case .binding(\.$colorScheme):
    return environment.setUserInterfaceStyle(state.colorScheme.userInterfaceStyle)
      .fireAndForget()

  case .binding(\.$appIcon):
    return environment.uiApplicationClient.setAlternateIconName(state.appIcon.rawValue)
      .fireAndForget()
    
  case .binding:
    return .none
  }
}
.binding()
