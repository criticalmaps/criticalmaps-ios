import ComposableArchitecture
import Foundation

private enum TwitterServiceKey: DependencyKey {
  static let liveValue = TwitterFeedService.live()
  static let testValue = TwitterFeedService.noop
}


public extension DependencyValues {
  var twitterService: TwitterFeedService {
    get { self[TwitterServiceKey.self] }
    set { self[TwitterServiceKey.self] = newValue }
  }
}
