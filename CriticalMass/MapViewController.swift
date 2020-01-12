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
    private let nextRideHandler: CMInApiHandling

    init(
        themeController: ThemeController,
        friendsVerificationController: FriendsVerificationController,
        nextRideHandler: CMInApiHandling
    ) {
        self.themeController = themeController
        self.friendsVerificationController = friendsVerificationController
        self.nextRideHandler = nextRideHandler
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

    private let gpsDisabledOverlayView: BlurryFullscreenOverlayView = {
        let view = BlurryFullscreenOverlayView.fromNib()
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
        gpsDisabledOverlayView.set(title: String.mapLayerInfoTitle, message: String.mapLayerInfo)
        gpsDisabledOverlayView.addButtonTarget(self, action: #selector(didTapGPSDisabledOverlayButton))
        view.addSubview(gpsDisabledOverlayView)
        gpsDisabledOverlayView.addLayoutsSameSizeAndOrigin(in: view)
        updateGPSDisabledOverlayVisibility()
    }

    public func presentMapInfo(with configuration: MapInfoView.Configuration) {
        dismissMapInfo()

        let view = MapInfoView.fromNib()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(with: configuration)
        self.view.addSubview(view)

        let topAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            topAnchor = self.view.safeAreaLayoutGuide.topAnchor
        } else {
            topAnchor = self.view.topAnchor
        }

        let widthLayoutConstraint = view.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -32)
        widthLayoutConstraint.priority = .init(rawValue: 999)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            widthLayoutConstraint,
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 400),
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])

        UIAccessibility.post(notification: .layoutChanged, argument: view)
    }

    public func dismissMapInfo() {
        view.subviews
            .compactMap { $0 as? MapInfoView }
            .forEach { $0.removeFromSuperview() }
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInitialLocation(notification:)), name: Notification.initialGpsDataReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGPSDisabledOverlayVisibility), name: Notification.observationModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: Notification.themeDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveFocusNotification(notification:)), name: Notification.focusLocation, object: nil)
    }

    private func configureMapView() {
        view.addSubview(mapView)
        mapView.addLayoutsSameSizeAndOrigin(in: view)
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

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
        focusOnLocation(location: location)

        guard Feature.events.isActive else { return }
        let coordinate = CLLocationCoordinate2D(
            latitude: location[keyPath: \Location.latitude],
            longitude: location[keyPath: \Location.longitude]
        )
        nextRideHandler.getNextRide(around: coordinate) { result in
            switch result {
            case let .success(rides):
                print(rides)
            case let .failure(error):
                ErrorHandler.default.handleError(error)
            }
        }
    }

    @objc func didReceiveFocusNotification(notification: Notification) {
        guard let location = notification.object as? Location else { return }
        focusOnLocation(location: location, zoomArea: 1000)
    }

    func focusOnLocation(location: Location, zoomArea: Double = 10000) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(location), latitudinalMeters: zoomArea, longitudinalMeters: zoomArea)
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
