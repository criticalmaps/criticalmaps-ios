//
//  MapViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    private let themeController: ThemeController!
    private let friendsVerificationController: FriendsVerificationController
    private var tileRenderer: MKTileOverlayRenderer?

    init(themeController: ThemeController, friendsVerificationController: FriendsVerificationController) {
        self.themeController = themeController
        self.friendsVerificationController = friendsVerificationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    private let nightThemeOverlay = DarkModeMapOverlay()
    public lazy var followMeButton: UserTrackingButton = {
        let button = UserTrackingButton(mapView: mapView)
        return button
    }()

    public var bottomContentOffset: CGFloat = 0 {
        didSet {
            mapView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: bottomContentOffset, right: 0)
        }
    }

    private var mapView = MKMapView(frame: .zero)

    private let gpsDisabledOverlayView: BlurryOverlayView = {
        let view = BlurryOverlayView.fromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.mapTitle
        configureNotifications()
        configureTileRenderer()
        configureMapView()
        condfigureGPSDisabledOverlayView()

        setNeedsStatusBarAppearanceUpdate()
    }

    private func configureTileRenderer() {
        guard themeController.currentTheme == .dark else {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
            }
            return
        }

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        } else {
            addTileRenderer()
        }
    }

    private func condfigureGPSDisabledOverlayView() {
        let gpsDisabledOverlayView = self.gpsDisabledOverlayView
        gpsDisabledOverlayView.set(title: String.mapLayerInfoTitle, message: String.mapLayerInfo)
        gpsDisabledOverlayView.addButtonTarget(self, action: #selector(didTapGPSDisabledOverlayButton))
        view.addSubview(gpsDisabledOverlayView)
        NSLayoutConstraint.activate([
            gpsDisabledOverlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            gpsDisabledOverlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        updateGPSDisabledOverlayVisibility()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: Notification.positionOthersChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInitialLocation(notification:)), name: Notification.initialGpsDataReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGPSDisabledOverlayVisibility), name: Notification.observationModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: Notification.themeDidChange, object: nil)
    }

    private func configureMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: mapView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 1),
            NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
        ])

        if #available(iOS 11.0, *) {
            mapView.register(BikeAnnoationView.self, forAnnotationViewWithReuseIdentifier: BikeAnnoationView.identifier)
        }
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    private func display(locations: [String: Location]) {
        guard LocationManager.accessPermission == .authorized else {
            return
        }
        var unmatchedLocations = locations
        var unmatchedAnnotations: [MKAnnotation] = []
        // update existing annotations
        mapView.annotations.compactMap { $0 as? IdentifiableAnnnotation }.forEach { annotation in
            if let location = unmatchedLocations[annotation.identifier] {
                annotation.location = location
                unmatchedLocations.removeValue(forKey: annotation.identifier)
            } else {
                unmatchedAnnotations.append(annotation)
            }
        }
        let annotations = unmatchedLocations.map { IdentifiableAnnnotation(location: $0.value, identifier: $0.key) }
        mapView.addAnnotations(annotations)

        // remove annotations that no longer exist
        mapView.removeAnnotations(unmatchedAnnotations)
    }

    @objc func didTapGPSDisabledOverlayButton() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

    @objc func updateGPSDisabledOverlayVisibility() {
        gpsDisabledOverlayView.isHidden = LocationManager.accessPermission != .denied
    }

    // MARK: Notifications

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themeController.currentTheme.style.statusBarStyle
    }

    @objc private func themeDidChange() {
        let theme = themeController.currentTheme
        guard theme == .dark else {
                if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
                } else {
                    removeTileRenderer()
                }
            return
        }
        configureTileRenderer()
    }

    private func removeTileRenderer() {
        tileRenderer = nil
        mapView.removeOverlay(nightThemeOverlay)
    }

    private func addTileRenderer() {
        tileRenderer = MKTileOverlayRenderer(tileOverlay: nightThemeOverlay)
        mapView.addOverlay(nightThemeOverlay, level: .aboveRoads)
    }

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
}

extension MapViewController: MKMapViewDelegate {
    // MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKUserLocation == false else {
            return nil
        }
        let annotationView: BikeAnnoationView
        if #available(iOS 11.0, *) {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: BikeAnnoationView.identifier, for: annotation) as! BikeAnnoationView
        } else {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: BikeAnnoationView.identifier) as? BikeAnnoationView ?? BikeAnnoationView()
            annotationView.annotation = annotation
        }

        if let identifiableAnnotation = (annotation as? IdentifiableAnnnotation),
            let signature = identifiableAnnotation.location.name {
            annotationView.isFriend = friendsVerificationController.isFriend(id: identifiableAnnotation.identifier, signature: signature)
        }
        return annotationView
    }

    func mapView(_: MKMapView, didChange mode: MKUserTrackingMode, animated _: Bool) {
        followMeButton.currentMode = UserTrackingButton.Mode(mode)
    }

    func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let renderer = self.tileRenderer else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return renderer
    }
}
