//
//  CriticalMapsTests

import CoreLocation
@testable import CriticalMaps
import XCTest

class NextRideManagerTests: XCTestCase {
    var nextRideManager: NextRideManager!
    private var networkLayer: MockNetworkLayer!

    override func setUp() {
        super.setUp()
        networkLayer = MockNetworkLayer()
        let apiHandler = CMInApiHandler(networkLayer: networkLayer)
        nextRideManager = NextRideManager(apiHandler: apiHandler)
    }

    override func tearDown() {
        nextRideManager = nil
        networkLayer = nil
        super.tearDown()
    }

    func testManagerShouldReturnCMBerlinRideWhenRideIsInFutureAndInRadius() {
        // given
        networkLayer.mockResponse = [
            Ride.TestData.cmBerlin,
            Ride.TestData.cmBarcelona
        ]
        // when
        let exp = expectation(description: "Wait for response")
        nextRideManager.getNextRide(around: CLLocationCoordinate2D.TestData.alexanderPlatz) { result in
            switch result {
            case let .success(ride):
                XCTAssertEqual(ride, Ride.TestData.cmBerlin)
            case .failure:
                XCTFail()
            }
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 1)
    }

    func testManagerShouldReturnNoRideWhenRideIsInFutureButNotInRadius() {
        // given
        networkLayer.mockResponse = [
            Ride.TestData.cmBerlin,
            Ride.TestData.cmBarcelona
        ]
        // when
        let exp = expectation(description: "Wait for response")
        nextRideManager.getNextRide(around: CLLocationCoordinate2D.TestData.rendsburg) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                XCTAssertEqual(error as! EventError, EventError.rideIsOutOfRangeError)
            }
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 1)
    }

    func testManagerShouldReturnNoRideWhenRideIsInPastButInRadius() {
        // given
        networkLayer.mockResponse = [
            Ride.TestData.completedCMBerlin
        ]
        // when
        let exp = expectation(description: "Wait for response")
        nextRideManager.getNextRide(around: CLLocationCoordinate2D.TestData.alexanderPlatz) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                XCTAssertEqual(error as! EventError, EventError.invalidDateError)
            }
            exp.fulfill()
        }
        // then
        wait(for: [exp], timeout: 1)
    }
}

extension Ride {
    enum TestData {
        static let completedCMBerlin = Ride(
            id: 123,
            slug: nil,
            title: "Critical Mass Berlin",
            description: nil,
            dateTime: Date().addingTimeInterval(-40000),
            location: "Mariannenplatz",
            latitude: 52.502148,
            longitude: 13.424356,
            estimatedParticipants: nil,
            estimatedDistance: nil,
            estimatedDuration: nil
        )
        static let cmBerlin = Ride(
            id: 123,
            slug: nil,
            title: "Critical Mass Berlin",
            description: nil,
            dateTime: Date().addingTimeInterval(40000),
            location: "Mariannenplatz",
            latitude: 52.502148,
            longitude: 13.424356,
            estimatedParticipants: nil,
            estimatedDistance: nil,
            estimatedDuration: nil
        )
        static let cmBarcelona = Ride(
            id: 345,
            slug: nil,
            title: "Critical Mass Barcelona",
            description: nil,
            dateTime: Date().addingTimeInterval(4400),
            location: "Arco del Triunfo",
            latitude: 41.391270,
            longitude: 2.180441,
            estimatedParticipants: nil,
            estimatedDistance: nil,
            estimatedDuration: nil
        )
    }
}

extension CLLocationCoordinate2D {
    enum TestData {
        static let rendsburg = CLLocationCoordinate2D(latitude: 54.308547, longitude: 9.656645)
        static let alexanderPlatz = CLLocationCoordinate2D(latitude: 52.524657, longitude: 13.413939)
    }
}
