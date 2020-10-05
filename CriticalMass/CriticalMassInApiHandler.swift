//
//  CriticalMaps

import CoreLocation
import Foundation

protocol CMInApiHandling {
    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        eventSearchRadius: Int,
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
        eventSearchRadius: Int,
        _ handler: @escaping ResultCallback<[Ride]>
    ) {
        let request = NextRidesRequest(coordinate: coordinate, radius: eventSearchRadius)
        networkLayer.get(request: request, completion: handler)
    }
}
