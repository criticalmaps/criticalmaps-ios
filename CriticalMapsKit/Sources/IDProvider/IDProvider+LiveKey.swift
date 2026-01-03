import ComposableArchitecture
import Foundation
import SharedKeys
import UIKit.UIDevice

extension IDProvider: DependencyKey {
  public static var liveValue: IDProvider {
    @Dependency(\.date) var date
    @Dependency(\.uuid) var uuid
    @Shared(.sessionID) var sessionID

    let id = sessionID ?? uuid().uuidString

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

public extension DependencyValues {
  var idProvider: IDProvider {
    get { self[IDProvider.self] }
    set { self[IDProvider.self] = newValue }
  }
}
