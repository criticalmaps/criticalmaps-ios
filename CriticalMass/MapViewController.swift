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

    public var bottomContentOffset: CGFloat = 0 {
        didSet {
            mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: bottomContentOffset, right: 0)
        }
    }

    override func loadView() {
        view = MKMapView(frame: .zero)
    }

    private var mapView: MKMapView {
        return view as! MKMapView
    }

    private let gpsDisabledOverlayView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.accessibilityViewIsModal = true
        view.effect = UIBlurEffect(style: .light)
        let label = UILabel()
        label.text = NSLocalizedString("map.layer.info", comment: "")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        view.contentView.addSubview(label)
        label.center = view.center
        label.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("map.title", comment: "")
        configureNotifications()
        configureMapView()
        condfigureGPSDisabledOverlayView()
    }

    private func condfigureGPSDisabledOverlayView() {
        view.addSubview(gpsDisabledOverlayView)

        gpsDisabledOverlayView.frame = view.bounds
        gpsDisabledOverlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        updateGPSDisabledOverlayVisibility()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: NSNotification.Name("positionOthersChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInitialLocation(notification:)), name: NSNotification.Name("initialGpsDataReceived"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGPSDisabledOverlayVisibility), name: NSNotification.Name("gpsStateChanged"), object: nil)
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

    @objc func updateGPSDisabledOverlayVisibility() {
        gpsDisabledOverlayView.isHidden = LocationManager.accessPermission == .authorized
    }

    public lazy var followMeButton: UserTrackingButton = {
        let button = UserTrackingButton(mapView: mapView)
        button.tintColor = .navigationOverlayForeground
        return button
    }()

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
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode == .none {
            followMeButton.currentMode = .none
        }
    }
}
