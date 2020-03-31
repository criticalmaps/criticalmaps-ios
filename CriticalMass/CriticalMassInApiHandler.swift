//
//  CriticalMaps

import CoreLocation
import Foundation

protocol CMInApiHandling {
    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback<[Ride]>
    )
}

struct CMInApiHandler: CMInApiHandling {
    private let networkLayer: NetworkLayer

    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }

    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback<[Ride]>
    ) {
        let request = NextRidesRequest(coordinate: coordinate)
        networkLayer.get(request: request, completion: handler)
    }
}
