import ComposableArchitecture
import Foundation
import SharedEnvironment
import SharedModels

public struct AppDelegate: ReducerProtocol {
  public init() {}
  
  @Dependency(\.backgroundQueue) public var backgroundQueue
  @Dependency(\.mainQueue) public var mainQueue
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
      return .merge(
        .concatenate(
          fileClient.loadUserSettings()
            .map(Action.userSettingsLoaded)
        )
      )

    case let .userSettingsLoaded(result):
      state = (try? result.get()) ?? state
      return .merge(
        setUserInterfaceStyle(state.appearanceSettings.colorScheme.userInterfaceStyle)
          // NB: This is necessary because UIKit needs at least one tick of the run loop before we
          //     can set the user interface style.
          .subscribe(on: mainQueue)
          .fireAndForget()
      )
    }
  }
}
