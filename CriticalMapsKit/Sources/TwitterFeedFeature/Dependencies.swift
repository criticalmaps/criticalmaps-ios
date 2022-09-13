import ComposableArchitecture
import Foundation

private enum TwitterServiceKey: TestDependencyKey {
  static let liveValue = TwitterFeedService.live()
  static let testValue = TwitterFeedService.noop
}


public extension DependencyValues {
  var twitterService: TwitterFeedService {
    get { self[TwitterServiceKey.self] }
    set { self[TwitterServiceKey.self] = newValue }
  }
}
