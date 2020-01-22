//
//  FriendAnnotationController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 22.01.20.
//  Copyright © 2020 Pokus Labs. All rights reserved.
//

import MapKit

class FriendAnnotation: IdentifiableAnnnotation {}

class FriendAnnotationController: AnnotationController<FriendAnnotation, FriendAnnotationView> {
    private var friendsVerificationController: FriendsVerificationController

    init(friendsVerificationController: FriendsVerificationController, mapView: MKMapView) {
        self.friendsVerificationController = friendsVerificationController
        super.init(mapView: mapView)
    }

    required init(mapView _: MKMapView) {
        fatalError("init(mapView:) has not been implemented")
    }

    public override func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: Notification.positionOthersChanged, object: nil)
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
        var unmatchedLocations = locations.filter { friendsVerificationController.isFriend(id: $0.key) }
        var unmatchedAnnotations: [MKAnnotation] = []
        // update existing annotations
        mapView.annotations.compactMap { $0 as? FriendAnnotation }.forEach { annotation in
            if let location = unmatchedLocations[annotation.identifier] {
                annotation.location = location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        }
        let annotations = unmatchedLocations.map { FriendAnnotation(location: $0.value, identifier: $0.key) }
        mapView.addAnnotations(annotations)

        // remove annotations that no longer exist
        mapView.removeAnnotations(unmatchedAnnotations)
    }
}
