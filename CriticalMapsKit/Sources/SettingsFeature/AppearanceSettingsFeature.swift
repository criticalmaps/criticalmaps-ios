import ComposableArchitecture
import FeedbackGeneratorClient
import Helpers
import SharedDependencies
import SharedModels
import UIApplicationClient
import UIKit.UIInterface

@Reducer
public struct AppearanceSettingsFeature {
  public init() {}
  
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.setUserInterfaceStyle) private var setUserInterfaceStyle
  @Dependency(\.feedbackGenerator) private var feedbackGenerator
  
  // MARK: State
  
  public typealias State = SharedModels.AppearanceSettings
  
  // MARK: Action
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<AppearanceSettings>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
    
    Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.$colorScheme):
        let style = state.colorScheme.userInterfaceStyle
        return .run { _ in
          await setUserInterfaceStyle(style)
        }

      case .binding(\.$appIcon):
        let appIcon = state.appIcon.rawValue
        return .merge(
          .run { _ in try await uiApplicationClient.setAlternateIconName(appIcon) },
          .run { _ in await feedbackGenerator.selectionChanged() }
        )

      case .binding:
        return .none
      }
    }
  }
}
