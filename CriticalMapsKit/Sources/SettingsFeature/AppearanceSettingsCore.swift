import ComposableArchitecture
import Helpers
import SharedDependencies
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

public struct AppearanceSettingsFeature: ReducerProtocol {
  public init() {}

  @Dependency(\.uiApplicationClient)
  public var uiApplicationClient
  @Dependency(\.setUserInterfaceStyle)
  public var setUserInterfaceStyle: @Sendable (UIUserInterfaceStyle) async -> Void

  
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
        let style = state.colorScheme.userInterfaceStyle
        return .fireAndForget {
          await setUserInterfaceStyle(style)
        }

      case .binding(\.$appIcon):
        return uiApplicationClient.setAlternateIconName(state.appIcon.rawValue)
          .fireAndForget()

      case .binding:
        return .none
      }
    }
  }
}
