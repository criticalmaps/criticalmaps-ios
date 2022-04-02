//
//  File.swift
//  File
//
//  Created by Malte on 29.07.21.
//

@testable import NextRideFeature
import SharedModels
import XCTest

class NextRideReqeustTests: XCTestCase {
  let fixedDate = { Date(timeIntervalSince1970: 1_557_057_968) }
  
  func test_constructor() throws {
    let coordinate = Coordinate(latitude: 13.13, longitude: 14.14)
    let radius = 20
    
    let request = NextRidesRequest(coordinate: coordinate, radius: radius, date: fixedDate, month: 5)
    
    let urlRequest = try request.makeRequest()
    let url = try XCTUnwrap(urlRequest.url)
    
    let queryItems = [
      "radius=20",
      "centerLongitude=14.14",
      "centerLatitude=13.13",
      "year=2020",
      "month=1"
    ]
    
    XCTAssertTrue(queryItems.contains(where: { url.absoluteString.contains($0) }))
  }
  
  func test_constructor_withCurrentDate() throws {
    let coordinate = Coordinate(latitude: 13.13, longitude: 14.14)
    let radius = 20
    let year = Date.getCurrent(\.year)
    let month = Date.getCurrent(\.month)
    
    let request = NextRidesRequest(coordinate: coordinate, radius: radius, month: month)
    
    let urlRequest = try request.makeRequest()
    let url = try XCTUnwrap(urlRequest.url)
    
    let queryItems = [
      "radius=20",
      "centerLongitude=14.14",
      "centerLatitude=13.13",
      "year=\(year)",
      "month=\(month)"
    ]
    
    XCTAssertTrue(queryItems.contains(where: { url.absoluteString.contains($0) }))
  }
}
