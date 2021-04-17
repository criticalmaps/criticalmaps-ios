//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import MapKit
import XCTest

class NextRidesRequestTests: XCTestCase {
    let request = NextRidesRequest(
        coordinate: CLLocationCoordinate2D(latitude: 42, longitude: 42),
        radius: 21
    )

    func testMakeRequest() throws {
        let month = Date.getCurrent(\.month)
        let year = Date.getCurrent(\.year)

        let urlRequest = try request.makeRequest()
        let outputString = urlRequest.url!.absoluteString
        let expectedOutput = "https://criticalmass.in/api/ride?centerLatitude=42&centerLongitude=42&month=\(month)&radius=21&year=\(year)"

        XCTAssertEqual(outputString, expectedOutput)
    }

    func testParseRespone_withNullLatAndLng() throws {
        let responseData = """
        [{
            "id":8091,
            "slug":null,
            "title":"Critical Mass Aachen 27.03.2020",
            "description":null,
            "dateTime":1585328400,
            "location":"Elisenbrunnen",
            "latitude":null,
            "longitude":null,
            "estimatedParticipants":null,
            "estimatedDistance":null,
            "estimatedDuration":null,
            "enabled": true
        }]
        """
        .data(using: .utf8)!

        let ride = Ride(
            id: 8091,
            slug: nil,
            title: "Critical Mass Aachen 27.03.2020",
            description: nil,
            dateTime: Date(timeIntervalSince1970: 1_585_328_400),
            location: "Elisenbrunnen",
            latitude: nil,
            longitude: nil,
            estimatedParticipants: nil,
            estimatedDistance: nil,
            estimatedDuration: nil,
            enabled: true,
            disabledReason: nil,
            disabledReasonMessage: nil,
            rideType: nil
        )

        let expectedRides = [ride]
        let rides = try request.parseResponse(data: responseData)
        XCTAssertEqual(expectedRides, rides)
    }

    func testParseRespone2() throws {
        let responseData = """
        [{
            "id":8091,
            "slug":null,
            "title":"Critical Mass Aachen 27.03.2020",
            "description":null,
            "dateTime":1585328400,
            "location":"Elisenbrunnen",
            "latitude":50.774167,
            "longitude":6.086944,
            "estimatedParticipants":null,
            "estimatedDistance":null,
            "estimatedDuration":null,
            "enabled": true
        }]
        """.data(using: .utf8)!

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
                enabled: true,
                disabledReason: nil,
                disabledReasonMessage: nil,
                rideType: nil
            )
        ]
        let rides = try request.parseResponse(data: responseData)
        XCTAssertEqual(expectedRides, rides)
    }

    func testParseRespone_withRideType() throws {
        let responseData = """
        [{
            "id":8091,
            "slug":null,
            "title":"Critical Mass Aachen 27.03.2020",
            "description":null,
            "dateTime":1585328400,
            "location":null,
            "latitude":null,
            "longitude":null,
            "estimatedParticipants":null,
            "estimatedDistance":null,
            "estimatedDuration":45.53,
            "enabled":true,
            "rideType":"CRITICAL_MASS"
        }]
        """.data(using: .utf8)!

        let expectedRides = [
            Ride(
                id: 8091,
                slug: nil,
                title: "Critical Mass Aachen 27.03.2020",
                description: nil,
                dateTime: Date(timeIntervalSince1970: 1_585_328_400),
                location: nil,
                latitude: nil,
                longitude: nil,
                estimatedParticipants: nil,
                estimatedDistance: nil,
                estimatedDuration: 45.53,
                enabled: true,
                disabledReason: nil,
                disabledReasonMessage: nil,
                rideType: .criticalMass
            )
        ]
        let rides = try request.parseResponse(data: responseData)
        XCTAssertEqual(expectedRides, rides)
    }

    func testParseRespone_withRideTypeAndOtherPropertiesSet() throws {
        let responseData = """
        [{
            "id":8091,
            "slug":"SLUG",
            "title":"Critical Mass Aachen 27.03.2020",
            "description":"DESCRIPTION",
            "dateTime":1585328400,
            "location":"LOCATION",
            "latitude":53.53,
            "longitude":13.13,
            "estimatedParticipants":1400,
            "estimatedDistance":33.22,
            "estimatedDuration":45.53,
            "enabled": true,
            "rideType": "CRITICAL_MASS",
            "socialDescription": "SOCIALDISTORTION"
        }]
        """.data(using: .utf8)!

        let expectedRides = [
            Ride(
                id: 8091,
                slug: "SLUG",
                title: "Critical Mass Aachen 27.03.2020",
                description: "DESCRIPTION",
                dateTime: Date(timeIntervalSince1970: 1_585_328_400),
                location: "LOCATION",
                latitude: 53.53,
                longitude: 13.13,
                estimatedParticipants: 1400,
                estimatedDistance: 33.22,
                estimatedDuration: 45.53,
                enabled: true,
                disabledReason: nil,
                disabledReasonMessage: nil,
                rideType: .criticalMass
            )
        ]
        let rides = try request.parseResponse(data: responseData)
        XCTAssertEqual(expectedRides, rides)
    }

    func testParseRespone_withNonUniformObjectsinResponse() throws {
        let responseData = """
        [
            {
                "id":8091,
                "slug":"SLUG",
                "title":"Critical Mass Aachen 27.03.2020",
                "description":"DESCRIPTION",
                "dateTime":1585328400,
                "location":"LOCATION",
                "latitude":53.53,
                "longitude":13.13,
                "estimatedParticipants":1400,
                "estimatedDistance":33.22,
                "estimatedDuration":45.53,
                "enabled": true,
                "rideType": "CRITICAL_MASS"
            },
            {
                "id":1,
                "slug":null,
                "title":"Critical Mass Aachen 27.03.2020",
                "description":"DESCRIPTION",
                "dateTime":1585328400,
                "location":"LOCATION",
                "latitude":null,
                "longitude":null,
                "estimatedParticipants":1400,
                "estimatedDistance":null,
                "estimatedDuration":45.53,
                "enabled": false,
                "rideType": "KIDICAL_MASS",
                "socialDescription": "SOCIALDISTORTION"
            }
        ]
        """.data(using: .utf8)!

        let expectedRides = [
            Ride(
                id: 8091,
                slug: "SLUG",
                title: "Critical Mass Aachen 27.03.2020",
                description: "DESCRIPTION",
                dateTime: Date(timeIntervalSince1970: 1_585_328_400),
                location: "LOCATION",
                latitude: 53.53,
                longitude: 13.13,
                estimatedParticipants: 1400,
                estimatedDistance: 33.22,
                estimatedDuration: 45.53,
                enabled: true,
                disabledReason: nil,
                disabledReasonMessage: nil,
                rideType: .criticalMass
            ),
            Ride(
                id: 1,
                slug: nil,
                title: "Critical Mass Aachen 27.03.2020",
                description: "DESCRIPTION",
                dateTime: Date(timeIntervalSince1970: 1_585_328_400),
                location: "LOCATION",
                latitude: nil,
                longitude: nil,
                estimatedParticipants: 1400,
                estimatedDistance: nil,
                estimatedDuration: 45.53,
                enabled: false,
                disabledReason: nil,
                disabledReasonMessage: nil,
                rideType: .kidicalMass
            )
        ]
        let rides = try request.parseResponse(data: responseData)
        XCTAssertEqual(expectedRides, rides)
    }
}
