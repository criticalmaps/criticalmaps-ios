//
//  MapViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    class IdentifiableAnnnotation: MKPointAnnotation {
        var identifier: String

        var location: Location {
            set {
                coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(newValue.latitude / 1_000_000), longitude: CLLocationDegrees(newValue.longitude / 1_000_000))
            }
            get {
                fatalError("Not implemented")
            }
        }

        init(location: Location, identifier: String) {
            self.identifier = identifier
            super.init()
            self.location = location
        }
    }

    override func loadView() {
        view = MKMapView(frame: .zero)
    }

    private var mapView: MKMapView {
        return self.view as! MKMapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNotifications()
        configureMapView()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: NSNotification.Name("positionOthersChanged"), object: nil)
    }

    private func configureMapView() {
        if #available(iOS 11.0, *) {
            mapView.register(BikeAnnoationView.self, forAnnotationViewWithReuseIdentifier: BikeAnnoationView.identifier)
        }
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
    }

    @objc private func positionsDidChange(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        display(locations: response.locations)
    }

    private func display(locations: [String: Location]) {
        var unmatchedLocations = locations
        var unmatchedAnnotations: [MKAnnotation] = []
        (mapView.annotations as? [IdentifiableAnnnotation])?.forEach({ annotation in
            if let location = unmatchedLocations[annotation.identifier] {
                annotation.location = location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        })
        let annotations = unmatchedLocations.map { IdentifiableAnnnotation(location: $0.value, identifier: $0.key) }
        mapView.addAnnotations(annotations)
        mapView.removeAnnotations(unmatchedAnnotations)
    }

    // MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if #available(iOS 11.0, *) {
            return mapView.dequeueReusableAnnotationView(withIdentifier: BikeAnnoationView.identifier, for: annotation)
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: BikeAnnoationView.identifier) ?? BikeAnnoationView()
            annotationView.annotation = annotation
            return annotationView
        }
    }
}
