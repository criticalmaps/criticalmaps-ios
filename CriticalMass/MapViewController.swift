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
    private var tileRenderer: MKTileOverlayRenderer?

    init(themeController: ThemeController) {
        self.themeController = themeController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Properties

    private lazy var annotationController: [AnnotationController] = {
        [BikeAnnotationController(mapView: self.mapView)]
    }()

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

        title = L10n.Map.title
        configureNotifications()
        configureTileRenderer()
        configureMapView()
        condfigureGPSDisabledOverlayView()

        annotationController
            .map { $0.annotationViewType }
            .forEach(mapView.register)

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
        gpsDisabledOverlayView.set(title: L10n.Map.Layer.Info.title, message: L10n.Map.Layer.info)
        gpsDisabledOverlayView.addButtonTarget(self, action: #selector(didTapGPSDisabledOverlayButton))
        view.addSubview(gpsDisabledOverlayView)
        NSLayoutConstraint.activate([
            gpsDisabledOverlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            gpsDisabledOverlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        updateGPSDisabledOverlayVisibility()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInitialLocation(notification:)), name: Notification.initialGpsDataReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGPSDisabledOverlayVisibility), name: Notification.observationModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: Notification.themeDidChange, object: nil)
    }

    private func configureMapView() {
        view.addSubview(mapView)
        mapView.addLayoutsSameSizeAndOrigin(in: view)
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    // GPS Disabled Overlay

    @objc func didTapGPSDisabledOverlayButton() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

    @objc func updateGPSDisabledOverlayVisibility() {
        gpsDisabledOverlayView.isHidden = LocationManager.accessPermission != .denied
    }

    // MARK: Notifications

    override var preferredStatusBarStyle: UIStatusBarStyle {
        themeController.currentTheme.style.statusBarStyle
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

        guard let matchingController = annotationController.first(where: { type(of: annotation) == $0.annotationType }) else {
            return nil
        }

        return mapView.dequeueReusableAnnotationView(ofType: matchingController.annotationViewType, with: annotation)
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
