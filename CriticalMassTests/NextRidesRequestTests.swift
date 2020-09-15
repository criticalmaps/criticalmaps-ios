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

    func testParseRespone() throws {
        let responseData = """
        [
            {
                \"id\":8091,
                \"slug\":null,
                \"title\":\"Critical Mass Aachen 27.03.2020\",
                \"description\":null,
                \"date_time\":1585328400,
                \"location\":\"Elisenbrunnen\",
                \"latitude\":50.774167,
                \"longitude\":6.086944,
                \"estimatedParticipants\":null,
                \"estimatedDistance\":null,
                \"estimatedDuration\":null
            }
        ]
        """.data(using: .utf8)!

        let request = NextRidesRequest(coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42), radius: 21)

        let expectedRides = [
            Ride(
                id: 8091,
                slug: nil,
                title: "Critical Mass Aachen 27.03.2020",
                description: nil,
                dateTime: Date(timeIntervalSince1970: 1_585_328_400),
                location: "Elisenbrunnen",
                latitude: 50.774167,
                longitude: 6.086944,
                estimatedParticipants: nil,
                estimatedDistance: nil,
                estimatedDuration: nil,
                disabledReason: nil,
                disabledReasonMessage: nil
            )
        ]
        let rides = try request.parseResponse(data: responseData)
        XCTAssertEqual(expectedRides, rides)
    }

    func test_injectedRadiusReflectInQuery() throws {
        let testRadius = 21
        let request = NextRidesRequest(coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42), radius: testRadius)
        let urlRequest = try request.makeRequest()

        let month = Date.getCurrent(\.month)
        let year = Date.getCurrent(\.year)
        let expectedQuery = "https://\(Constants.criticalmassInEndpoint)/api/ride?centerLatitude=42&centerLongitude=42&month=\(month)&radius=\(testRadius)&year=\(year)"
        guard let urlString = urlRequest.url?.absoluteString else {
            XCTFail("URLRequest does not have a url")
            return
        }
        XCTAssertEqual(Set(expectedQuery), Set(urlString))
    }
}
