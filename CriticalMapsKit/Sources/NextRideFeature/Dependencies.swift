import ComposableArchitecture
import Foundation

public extension DependencyValues {
  var nextRideService: NextRideService {
    get { self[NextRideServiceKey.self] }
    set { self[NextRideServiceKey.self] = newValue }
  }
  
  var coordinateObfuscator: CoordinateObfuscator {
    get { self[CoordinateObfuscatorKey.self] }
    set { self[CoordinateObfuscatorKey.self] = newValue }
  }
}

// MARK: Keys

enum CoordinateObfuscatorKey: DependencyKey {
  static let liveValue = CoordinateObfuscator.live
  static let testValue = CoordinateObfuscator.live
}

enum NextRideServiceKey: DependencyKey {
  static let liveValue = NextRideService.live()
  static let testValue = NextRideService.noop
}
