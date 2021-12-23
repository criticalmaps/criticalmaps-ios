import ApiClient
import ComposableArchitecture
import ComposableCoreLocation
import FileClient
import Helpers
import IDProvider
import Logger
import MapFeature
import MapKit
import NextRideFeature
import SettingsFeature
import SharedModels
import UIApplicationClient
import UserDefaultsClient


public enum AppDelegateAction: Equatable {
  case didFinishLaunching
  case userSettingsLoaded(Result<UserSettings, NSError>)
}

public struct AppDelegateEnvironment {
  public var backgroundQueue: AnySchedulerOf<DispatchQueue>
  public var fileClient: FileClient
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var setUserInterfaceStyle: (UIUserInterfaceStyle) -> Effect<Never, Never>

  public init(
    backgroundQueue: AnySchedulerOf<DispatchQueue>,
    fileClient: FileClient,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    setUserInterfaceStyle: @escaping (UIUserInterfaceStyle) -> Effect<Never, Never>
  ) {
    self.backgroundQueue = backgroundQueue
    self.fileClient = fileClient
    self.mainQueue = mainQueue
    self.setUserInterfaceStyle = setUserInterfaceStyle
  }
  
  public static let live = Self(
    backgroundQueue: DispatchQueue(label: "background-queue").eraseToAnyScheduler(),
    fileClient: .live,
    mainQueue: .main,
    setUserInterfaceStyle: { userInterfaceStyle in
      .fireAndForget {
        UIApplication.shared.firstWindowSceneWindow?.overrideUserInterfaceStyle = userInterfaceStyle
      }
    }
  )
}

let appDelegateReducer = Reducer<
  UserSettings, AppDelegateAction, AppDelegateEnvironment
> { state, action, environment in
  switch action {
  case .didFinishLaunching:
    
    return .merge(
      .concatenate(
        environment.fileClient.loadUserSettings()
          .map(AppDelegateAction.userSettingsLoaded)
      )
    )

  case let .userSettingsLoaded(result):
    state = (try? result.get()) ?? state
    return .merge(
      environment.setUserInterfaceStyle(state.appearanceSettings.colorScheme.userInterfaceStyle)
        // NB: This is necessary because UIKit needs at least one tick of the run loop before we
        //     can set the user interface style.
        .subscribe(on: environment.mainQueue)
        .fireAndForget()
    )
  }
}
