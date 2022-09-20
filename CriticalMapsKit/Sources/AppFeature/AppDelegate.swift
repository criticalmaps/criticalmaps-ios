import ComposableArchitecture
import Foundation
import SharedDependencies
import SharedModels

public struct AppDelegate: ReducerProtocol {
  public init() {}
  
  @Dependency(\.fileClient) public var fileClient
  @Dependency(\.setUserInterfaceStyle) public var setUserInterfaceStyle

  public typealias State = UserSettings
  
  public enum Action: Equatable {
    case didFinishLaunching
    case userSettingsLoaded(Result<State, NSError>)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .didFinishLaunching:
      return fileClient.loadUserSettings().map(Action.userSettingsLoaded)

    case let .userSettingsLoaded(result):
      state = (try? result.get()) ?? state
      let style = state.appearanceSettings.colorScheme.userInterfaceStyle
      return .fireAndForget {
        await setUserInterfaceStyle(style)
      }
    }
  }
}
