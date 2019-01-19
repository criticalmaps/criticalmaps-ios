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
                coordinate = CLLocationCoordinate2D(latitude: newValue.latitude, longitude: newValue.longitude)
            }
            @available(*, unavailable)
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
        return view as! MKMapView
    }

    private let followMeButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        button.layer.cornerRadius = 3
        button.setImage(UIImage(named: "Arrow"), for: .normal)
        button.backgroundColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("map.title", comment: "")
        configureNotifications()
        configureMapView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureFollowMeButton()
    }

    private func configureFollowMeButton() {
        view.addSubview(followMeButton)

        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0

        followMeButton.center = CGPoint(x: view.bounds.width - followMeButton.bounds.width, y: view.bounds.height - followMeButton.bounds.height - tabBarHeight)
        followMeButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        followMeButton.addTarget(self, action: #selector(didTapfollowMeButton), for: .touchUpInside)
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: NSNotification.Name("positionOthersChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInitialLocation(notification:)), name: NSNotification.Name("initialGpsDataReceived"), object: nil)
    }

    private func configureMapView() {
        if #available(iOS 11.0, *) {
            mapView.register(BikeAnnoationView.self, forAnnotationViewWithReuseIdentifier: BikeAnnoationView.identifier)
        }
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    private func display(locations: [String: Location]) {
        var unmatchedLocations = locations
        var unmatchedAnnotations: [MKAnnotation] = []
        // update existing annotations
        mapView.annotations.compactMap { $0 as? IdentifiableAnnnotation }.forEach({ annotation in
            if let location = unmatchedLocations[annotation.identifier] {
                annotation.location = location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        })
        let annotations = unmatchedLocations.map { IdentifiableAnnnotation(location: $0.value, identifier: $0.key) }
        mapView.addAnnotations(annotations)

        // remove annotations that no longer exist
        mapView.removeAnnotations(unmatchedAnnotations)
    }

    @objc func didTapfollowMeButton() {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }

    // MARK: Notifications

    @objc private func positionsDidChange(notification: Notification) {
        guard let response = notification.object as? ApiResponse else { return }
        display(locations: response.locations)
    }

    @objc func didReceiveInitialLocation(notification: Notification) {
        guard let location = notification.object as? Location else { return }
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(location), latitudinalMeters: 10000, longitudinalMeters: 10000)
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: true)
    }

    // MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKUserLocation == false else {
            return nil
        }
        if #available(iOS 11.0, *) {
            return mapView.dequeueReusableAnnotationView(withIdentifier: BikeAnnoationView.identifier, for: annotation)
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: BikeAnnoationView.identifier) ?? BikeAnnoationView()
            annotationView.annotation = annotation
            return annotationView
        }
    }
}
