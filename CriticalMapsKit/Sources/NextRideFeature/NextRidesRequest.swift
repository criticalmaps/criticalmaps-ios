import ApiClient
import CoreLocation
import SharedModels

public extension Request {
  static func nextRides(
    coordinate: Coordinate,
    radius: Int,
    date: () -> Date = Date.init,
    month: Int
  ) -> Self {
    Self(
      endpoint: .criticalmass,
      httpMethod: .get,
      queryItems: [
        URLQueryItem(name: NextRideQueryKeys.centerLongitude, value: String(coordinate.longitude)),
        URLQueryItem(name: NextRideQueryKeys.centerLatitude, value: String(coordinate.latitude)),
        URLQueryItem(name: NextRideQueryKeys.radius, value: String(radius)),
        URLQueryItem(name: NextRideQueryKeys.year, value: String(Date.getCurrent(\.year, date))),
        URLQueryItem(name: NextRideQueryKeys.month, value: String(month))
      ]
    )
  }
}

// MARK: Helper

enum NextRideQueryKeys {
  static let centerLatitude = "centerLatitude"
  static let centerLongitude = "centerLongitude"
  static let radius = "radius"
  static let year = "year"
  static let month = "month"
}
