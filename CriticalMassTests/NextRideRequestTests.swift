//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import MapKit
import XCTest

class NextRideRequestTests: XCTestCase {
    func testMakeRequest() throws {
        let month = Date.getCurrent(\.month)
        let year = Date.getCurrent(\.year)

        let request = NextRideRequest(coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42), radius: 21)
        let urlRequest = try request.makeRequest()
        let outputString = urlRequest.url!.absoluteString
        let expectedOutput = "https://criticalmass.in/api/ride?year=\(year)&radius=21&month=\(month)&centerLongitude=42&centerLatitude=42"

        XCTAssertEqual(outputString, expectedOutput)
    }
}
