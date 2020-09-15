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
    private let searchRadius: Int

    init(networkLayer: NetworkLayer, searchRadius: Int) {
        self.networkLayer = networkLayer
        self.searchRadius = searchRadius
    }

    func getNextRide(
        around coordinate: CLLocationCoordinate2D,
        _ handler: @escaping ResultCallback<[Ride]>
    ) {
        let request = NextRidesRequest(coordinate: coordinate, radius: searchRadius)
        networkLayer.get(request: request, completion: handler)
    }
}
