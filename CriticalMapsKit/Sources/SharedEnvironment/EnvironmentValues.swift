import ApiClient
import ComposableArchitecture
import IDProvider
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
  var uiApplicationClient: UIApplicationClient {
    get { self[UIApplicationClientKey.self] }
    set { self[UIApplicationClientKey.self] = newValue }
  }
  
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClientKey.self] }
    set { self[UserDefaultsClientKey.self] = newValue }
  }
  
  var idProvider: IDProvider {
    get { self[IDProviderKey.self] }
    set { self[IDProviderKey.self] = newValue }
  }
  
  var apiClient: APIClient {
    get { self[ApiClientKey.self] }
    set { self[ApiClientKey.self] = newValue }
  }
  
  var locationAndChatService: LocationsAndChatDataService {
    get { self[LocationAndChatServiceKey.self] }
    set { self[LocationAndChatServiceKey.self] = newValue }
  }
}


// MARK: Keys



enum ApiClientKey: DependencyKey {
  static let liveValue = APIClient.live
  static let testValue = APIClient.noop
}

enum IDProviderKey: DependencyKey {
  static let liveValue = IDProvider.live()
  static let testValue = IDProvider.noop
}

enum LocationAndChatServiceKey: DependencyKey {
  static let liveValue = LocationsAndChatDataService.live()
  static let testValue = LocationsAndChatDataService.failing
}

enum UserDefaultsClientKey: DependencyKey {
  static let liveValue = UserDefaultsClient.live()
  static let testValue = UserDefaultsClient.noop
}

enum UIApplicationClientKey: DependencyKey {
  static let liveValue = UIApplicationClient.live
  static let testValue = UIApplicationClient.noop
}
