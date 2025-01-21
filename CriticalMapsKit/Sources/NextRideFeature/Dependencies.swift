import ComposableArchitecture
import Foundation

public extension DependencyValues {
  var nextRideService: NextRideService {
    get { self[NextRideService.self] }
    set { self[NextRideService.self] = newValue }
  }

  var coordinateObfuscator: CoordinateObfuscator {
    get { self[CoordinateObfuscator.self] }
    set { self[CoordinateObfuscator.self] = newValue }
  }
}
