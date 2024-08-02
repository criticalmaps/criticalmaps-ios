import ComposableArchitecture
import FileClient
import Foundation
import SharedDependencies
import SharedModels

public struct AppDelegate: Reducer {
  public init() {}

  @Dependency(\.fileClient) var fileClient
  @Dependency(\.setUserInterfaceStyle) var setUserInterfaceStyle

  public typealias State = UserSettings

  public enum Action: Equatable {
    case didFinishLaunching
    case userSettingsLoaded(TaskResult<State>)
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .didFinishLaunching:
      return .run { send in
        await send(
          await .userSettingsLoaded(
            TaskResult {
              try await fileClient.loadUserSettings()
            }
          )
        )
      }

    case let .userSettingsLoaded(result):
      state = (try? result.value) ?? state
      let style = state.appearanceSettings.colorScheme.userInterfaceStyle
      return .run { _ in
        await setUserInterfaceStyle(style)
      }
    }
  }
}
