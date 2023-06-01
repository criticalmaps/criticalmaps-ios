import ComposableArchitecture
import FileClient
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
    case userSettingsLoaded(TaskResult<State>)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .didFinishLaunching:
      return .task {
        await .userSettingsLoaded(
          TaskResult {
            try await fileClient.loadUserSettings()
          }
        )
      }

    case let .userSettingsLoaded(result):
      state = (try? result.value) ?? state
      let style = state.appearanceSettings.colorScheme.userInterfaceStyle
      return .fireAndForget {
        await setUserInterfaceStyle(style)
      }
    }
  }
}
