//
// Created for CriticalMaps in 2020

@testable import CriticalMaps
import Foundation

class MockIDProvider: IDProvider {
    var token: String = "MockTocken"

    var mockID: String?
    var id: String {
        if let mockID = mockID {
            return mockID
        } else {
            return UUID().uuidString
        }
    }

    static func hash(id: String, currentDate _: Date) -> String {
        id
    }
}
