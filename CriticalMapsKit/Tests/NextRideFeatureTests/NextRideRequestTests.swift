import ApiClient
import Foundation
import NextRideFeature
import SharedModels
import Testing

struct NextRideReqeustTests {
  let fixedDate = { Date(timeIntervalSince1970: 1557057968) }
  
  @Test
  func constructor() throws {
    let coordinate = Coordinate(latitude: 13.13, longitude: 14.14)
    let radius = 20
    
    let request: Request = .nextRides(
      coordinate: coordinate,
      radius: radius,
      date: fixedDate,
      month: 5
    )
    
    let urlRequest = try request.makeRequest()
    let url = try #require(urlRequest.url)
    
    let queryItems = [
      "radius=20",
      "centerLongitude=14.14",
      "centerLatitude=13.13",
      "year=2020",
      "month=5"
    ]
    
    #expect(queryItems.contains(where: { url.absoluteString.contains($0) }))
  }
  
  @Test
  func constructor_withCurrentDate() throws {
    let coordinate = Coordinate(latitude: 13.13, longitude: 14.14)
    let radius = 20
    let year = Date.getCurrent(\.year)
    let month = Date.getCurrent(\.month)
    
    let request: Request = .nextRides(
      coordinate: coordinate,
      radius: radius,
      month: month
    )

    let urlRequest = try request.makeRequest()
    let url = try #require(urlRequest.url)
    
    let queryItems = [
      "radius=20",
      "centerLongitude=14.14",
      "centerLatitude=13.13",
      "year=\(year)",
      "month=\(month)"
    ]
    
    #expect(queryItems.contains(where: { url.absoluteString.contains($0) }))
  }
}
