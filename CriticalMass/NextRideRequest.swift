//
//  CriticalMaps

import CoreLocation

struct NextRideRequest: APIRequestDefining {
    private enum QueryKeys {
        static let centerLatitude: String = "centerLatitude"
        static let centerLongitude: String = "centerLongitude"
        static let radius: String = "radius"
        static let year: String = "year"
        static let month: String = "month"
    }

    typealias ResponseDataType = [Ride]
    var endpoint: Endpoint = Endpoint(
        baseUrl: Constants.criticalmassInEndpoint,
        path: "/api/ride"
    )
    var headers: HTTPHeaders?
    var httpMethod: HTTPMethod = .get

    let coordinate: CLLocationCoordinate2D
    let radius: Int
    private let year = Date.getCurrent(\.year)
    private let month = Date.getCurrent(\.month)

    init(coordinate: CLLocationCoordinate2D, radius: Int = 10) {
        self.coordinate = coordinate
        self.radius = radius
    }

    func getQueryItems() -> [URLQueryItem]? {
        [
            URLQueryItem(name: QueryKeys.centerLatitude, value: String(describing: coordinate.latitude)),
            URLQueryItem(name: QueryKeys.centerLongitude, value: String(describing: coordinate.longitude)),
            URLQueryItem(name: QueryKeys.radius, value: String(describing: radius)),
            URLQueryItem(name: QueryKeys.year, value: String(describing: year)),
            URLQueryItem(name: QueryKeys.month, value: String(describing: month)),
        ]
    }

    func parseResponse(data: Data) throws -> ResponseDataType {
        let decoder = JSONDecoder.decoder(dateDecodingStrategy: .secondsSince1970)
        return try decoder.decode(ResponseDataType.self, from: data)
    }
}

private extension Date {

    /// Get a component representation of todays Date as Int.
    /// - Parameter keyPath:
    /// - Returns: DateComponent representation as Int. Returns 0 when component is not available
    static func getCurrent(_ keyPath: KeyPath<DateComponents, Int?>) -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let component = components[keyPath: keyPath] ?? 0
        return component
    }
}
