import ComposableArchitecture
import FeedbackGeneratorClient
import Helpers
import SharedDependencies
import SharedModels
import UIApplicationClient
import UIKit

@Reducer
public struct AppearanceSettingsFeature {
  public init() {}
  
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.setUserInterfaceStyle) private var setUserInterfaceStyle
  @Dependency(\.feedbackGenerator) private var feedbackGenerator
  
  // MARK: State
  
  @ObservableState
  public struct State: Equatable {
    @Shared(.appearanceSettings)
    fileprivate var settings = AppearanceSettings()
    
    public var appIcon: AppIcon
    public var colorScheme: AppearanceSettings.ColorScheme
    
    public init(
      appIcon: AppIcon = .appIcon2,
      colorScheme: AppearanceSettings.ColorScheme = .system
    ) {
      self.appIcon = appIcon
      self.colorScheme = colorScheme
    }
  }
  
  // MARK: Action
  
  public enum Action: Equatable, BindableAction {
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce<State, Action> { state, action in
      switch action {
      case .binding(\.colorScheme):
        let colorScheme = state.colorScheme
        state.$settings.withLock { $0.colorScheme = colorScheme }
        return .run { _ in
          await setUserInterfaceStyle(colorScheme.userInterfaceStyle)
        }

      case .binding(\.appIcon):
        let appIcon = state.appIcon
        state.$settings.withLock { $0.appIcon = appIcon }
        return .merge(
          .run { _ in try await uiApplicationClient.setAlternateIconName(appIcon.rawValue) },
          .run { _ in await feedbackGenerator.selectionChanged() }
        )

      case .binding:
        return .none
      }
    }
  }
}

extension AppearanceSettingsFeature.State {
  init(appearanceSettings: AppearanceSettings) {
    self.init(
      appIcon: appearanceSettings.appIcon,
      colorScheme: appearanceSettings.colorScheme
    )
  }
}
