import ComposableArchitecture
import Foundation
import UIKit.UIDevice
import UserDefaultsClient

extension IDProvider: DependencyKey {
  public static var liveValue: IDProvider {
    @Dependency(\.userDefaultsClient) var defaultsClient
    @Dependency(\.date) var date
    
    let id = defaultsClient.getSessionID ?? UUID().uuidString
    
    return Self(
      id: {
        IDProvider.hash(
          id: id,
          currentDate: date.callAsFunction
        )
      },
      token: { id }
    )
  }
}

extension DependencyValues {
  public var idProvider: IDProvider {
    get { self[IDProvider.self] }
    set { self[IDProvider.self] = newValue }
  }
}
