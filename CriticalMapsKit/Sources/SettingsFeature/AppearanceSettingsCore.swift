import ComposableArchitecture
import Helpers
import SharedEnvironment
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

public struct AppearanceSettingsFeature: ReducerProtocol {
  public init() {}

  @Dependency(\.uiApplicationClient)
  public var uiApplicationClient
  @Dependency(\.setUserInterfaceStyle)
  public var setUserInterfaceStyle: (UIUserInterfaceStyle) -> Effect<Never, Never>

  
  // MARK: State
  
  public typealias State = SharedModels.AppearanceSettings
  
  // MARK: Action
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<AppearanceSettings>)
  }
  
  public var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    
    Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.$colorScheme):
        return setUserInterfaceStyle(state.colorScheme.userInterfaceStyle)
          .fireAndForget()

      case .binding(\.$appIcon):
        return uiApplicationClient.setAlternateIconName(state.appIcon.rawValue)
          .fireAndForget()

      case .binding:
        return .none
      }
    }
  }
}
