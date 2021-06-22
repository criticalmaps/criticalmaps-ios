//
//  File.swift
//  
//
//  Created by Malte on 08.06.21.
//

import ApiClient
import CoreLocation
import SharedModels

public struct NextRideQuery: Codable {
  let centerLatitude: CLLocationDegrees
  let centerLongitude: CLLocationDegrees
  let radius: Int
  var year = Date.getCurrent(\.year)
  var month = Date.getCurrent(\.month)
}

public struct NextRidesRequest: APIRequest {
  public typealias ResponseDataType = [Ride]
  public var endpoint = Endpoint(
    baseUrl: Endpoints.criticalmassInEndpoint,
    path: "/api/ride"
  )
  public var headers: HTTPHeaders?
  public var httpMethod: HTTPMethod = .get
  var queryItem: NextRideQuery?
  public var body: Data?
  
  init(coordinate: Coordinate, radius: Int) {
    queryItem = NextRideQuery(
      centerLatitude: coordinate.latitude,
      centerLongitude: coordinate.longitude,
      radius: radius
    )
  }
  
  public func parseResponse(data: Data) throws -> ResponseDataType {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try data.decoded(decoder: decoder)
  }
}
