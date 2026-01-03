import ComposableArchitecture
import FeedbackGeneratorClient
import Helpers
import SharedKeys
import SharedModels
import UIApplicationClient
import UIKit

@Reducer
public struct AppearanceSettingsFeature: Sendable {
  public init() {}
  
  // MARK: State
  
  @ObservableState
  public struct State: Equatable, Sendable {
    @Shared(.appearanceSettings) var settings
    
    public var appIcon: AppIcon
    public var colorScheme: AppearanceSettings.ColorScheme
    
    public init(
      appIcon: AppIcon = .primary,
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
  
  // MARK: Reducer
  
  @Dependency(\.uiApplicationClient) private var uiApplicationClient
  @Dependency(\.feedbackGenerator) private var feedbackGenerator
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.colorScheme):
        let colorScheme = state.colorScheme
        state.$settings.withLock { $0.colorScheme = colorScheme }
        return .run { _ in
          await uiApplicationClient.setUserInterfaceStyle(colorScheme.userInterfaceStyle)
        }

      case .binding(\.appIcon):
        let appIcon = state.appIcon
        state.$settings.withLock { $0.appIcon = appIcon }
        return .merge(
          .run { _ in
            do {
              try await uiApplicationClient.setAlternateIconName(appIcon.rawValue)
            } catch {
              debugPrint(error)
            }
          },
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
