import ComposableArchitecture
import Foundation

private enum MastodonServiceKey: DependencyKey {
  static let liveValue = TootService.live()
  static let testValue = TootService.noop
}


public extension DependencyValues {
  var tootService: TootService {
    get { self[MastodonServiceKey.self] }
    set { self[MastodonServiceKey.self] = newValue }
  }
}
