//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import MapKit
import XCTest

class NextRidesRequestTests: XCTestCase {
    func testMakeRequest() throws {
        let month = Date.getCurrent(\.month)
        let year = Date.getCurrent(\.year)

        let request = NextRidesRequest(coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42), radius: 21)
        let urlRequest = try request.makeRequest()
        let outputString = urlRequest.url!.absoluteString
        let expectedOutput = "https://criticalmass.in/api/ride?centerLatitude=42&centerLongitude=42&month=\(month)&radius=21&year=\(year)"

        XCTAssertEqual(outputString, expectedOutput)
    }
}
