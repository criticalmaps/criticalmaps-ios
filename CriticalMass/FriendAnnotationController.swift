//
//  FriendAnnotationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 22.01.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

import MapKit

class FriendAnnotation: IdentifiableAnnnotation<Friend> {}

class FriendAnnotationController: AnnotationController<FriendAnnotation, FriendAnnotationView, Friend> {
    private var friendsVerificationController: FriendsVerificationController

    init(friendsVerificationController: FriendsVerificationController, mapView: MKMapView) {
        self.friendsVerificationController = friendsVerificationController
        super.init(mapView: mapView)
    }

    required init(mapView _: MKMapView) {
        fatalError("init(mapView:) has not been implemented")
    }

    public override func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: .positionOthersChanged, object: nil)
    }

    @objc private func positionsDidChange(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        display(locations: response.locations)
    }

    private func display(locations: [String: Location]) {
        guard Feature.friends.isActive else {
            return
        }
        guard LocationManager.accessPermission == .authorized else {
            Logger.log(.info, log: .map, "Bike annotations cannot be displayed because no GPS Access permission granted", parameter: LocationManager.accessPermission.rawValue)
            return
        }
        let filteredLocations = locations.filter { friendsVerificationController.isFriend(id: $0.key) }
        let allTuples: [(identifier: String, location: Location, object: Friend)] = filteredLocations.compactMap {
            guard let friend = friendsVerificationController.friend(for: $0.key) else {
                return nil
            }
            return (identifier: $0.key, location: $0.value, object: friend)
        }

        let mappedLocations = allTuples.reduce(into: [String: (Location, Friend)]()) { result, value in
            result[value.identifier] = (value.location, value.object)
        }
        updateAnnotations(locations: mappedLocations)
    }
}
