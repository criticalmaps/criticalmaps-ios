import ApiClient
import ComposableArchitecture
import FileClient
import IDProvider
import PathMonitorClient
import SwiftUI
import UIApplicationClient
import UserDefaultsClient

public extension EnvironmentValues {
  /// Environment key to get the apps connectivity state
  var connectivity: Bool {
    get { self[ConnectionStateKey.self] }
    set { self[ConnectionStateKey.self] = newValue }
  }
}

private struct ConnectionStateKey: EnvironmentKey {
  static var defaultValue: Bool { true }
}


public extension DependencyValues {
  var apiClient: APIClient {
    get { self[ApiClientKey.self] }
    set { self[ApiClientKey.self] = newValue }
  }
  
  var backgroundQueue: AnySchedulerOf<DispatchQueue> {
    get { self[BackgroundQueueKey.self] }
    set { self[BackgroundQueueKey.self] = newValue }
  }
  
  var fileClient: FileClient {
    get { self[FileClientKey.self] }
    set { self[FileClientKey.self] = newValue }
  }
  
  var idProvider: IDProvider {
    get { self[IDProviderKey.self] }
    set { self[IDProviderKey.self] = newValue }
  }
  
  var locationAndChatService: LocationsAndChatDataService {
    get { self[LocationAndChatServiceKey.self] }
    set { self[LocationAndChatServiceKey.self] = newValue }
  }
  
  var pathMonitorClient: PathMonitorClient {
    get { self[PathMonitorClientKey.self] }
    set { self[PathMonitorClientKey.self] = newValue }
  }
  
  var setUserInterfaceStyle: SetUserInterfaceStyleEffect {
    get { self[SetUserInterfaceStyleKey.self] }
    set { self[SetUserInterfaceStyleKey.self] = newValue }
  }

  var uiApplicationClient: UIApplicationClient {
    get { self[UIApplicationClientKey.self] }
    set { self[UIApplicationClientKey.self] = newValue }
  }
  
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClientKey.self] }
    set { self[UserDefaultsClientKey.self] = newValue }
  }
}


// MARK: Keys


enum ApiClientKey: DependencyKey {
  static let liveValue = APIClient.live
  static let testValue = APIClient.noop
}

enum BackgroundQueueKey: DependencyKey {
  static let liveValue: AnySchedulerOf<DispatchQueue> = DispatchQueue(label: "background-queue").eraseToAnyScheduler()
  static let testValue: AnySchedulerOf<DispatchQueue> = .immediate
}

enum FileClientKey: DependencyKey {
  static let liveValue = FileClient.live
  static let testValue = FileClient.noop
}

enum IDProviderKey: DependencyKey {
  static let liveValue = IDProvider.live()
  static let testValue = IDProvider.noop
}

enum LocationAndChatServiceKey: DependencyKey {
  static let liveValue = LocationsAndChatDataService.live()
  static let testValue = LocationsAndChatDataService.failing
}

enum PathMonitorClientKey: DependencyKey {
  static let liveValue = PathMonitorClient.live(queue: .main)
  static let testValue = PathMonitorClient.satisfied
}

public typealias SetUserInterfaceStyleEffect = @Sendable (UIUserInterfaceStyle) async -> Void
enum SetUserInterfaceStyleKey: DependencyKey {
  
  static let liveValue: SetUserInterfaceStyleEffect = { userInterfaceStyle in
    await MainActor.run {
      UIApplication.shared.firstWindowSceneWindow?.overrideUserInterfaceStyle = userInterfaceStyle
    }
  }
  static let testValue: SetUserInterfaceStyleEffect = { _ in () }
}

enum UserDefaultsClientKey: DependencyKey {
  static let liveValue = UserDefaultsClient.live()
  static let testValue = UserDefaultsClient.noop
}

enum UIApplicationClientKey: DependencyKey {
  static let liveValue = UIApplicationClient.live
  static let testValue = UIApplicationClient.noop
}
