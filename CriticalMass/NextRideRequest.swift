//
//  CriticalMaps

import CoreLocation

struct NextRideQuery: Codable {
    let centerLatitude: CLLocationDegrees
    let centerLongitude: CLLocationDegrees
    let radius: Int
    let year = Date.getCurrent(\.year)
    let month = Date.getCurrent(\.month)
}

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
    var queryItem: NextRideQuery?

    init(coordinate: CLLocationCoordinate2D, radius: Int = 10) {
        queryItem = NextRideQuery(centerLatitude: coordinate.latitude, centerLongitude: coordinate.longitude, radius: radius)
    }

    func parseResponse(data: Data) throws -> ResponseDataType {
        let decoder = JSONDecoder.decoder(dateDecodingStrategy: .secondsSince1970)
        return try decoder.decode(ResponseDataType.self, from: data)
    }
}
