//
//  MapViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    private let themeController: ThemeController
    private let friendsVerificationController: FriendsVerificationController
    private var tileRenderer: MKTileOverlayRenderer?
    private let nextRideManager: NextRideManager

    private let mapInfoViewController = MapInfoViewController.fromNib()

    init(
        themeController: ThemeController,
        friendsVerificationController: FriendsVerificationController,
        nextRideManager: NextRideManager
    ) {
        self.themeController = themeController
        self.friendsVerificationController = friendsVerificationController
        self.nextRideManager = nextRideManager

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

    private var cmAnnotation: CriticalMassAnnotation?

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
        registerAnnoationViews()
        setupMapInfoViewController()

        setNeedsStatusBarAppearanceUpdate()
    }

    private func registerAnnoationViews() {
        annotationController
            .map { $0.annotationViewType }
            .forEach(mapView.register)
    }

    private func setupMapInfoViewController() {
        add(mapInfoViewController)
        mapInfoViewController.view.addLayoutsSameSizeAndOrigin(in: view)
        mapInfoViewController.tapHandler = { [unowned self] in
            guard let cmAnnotation = self.cmAnnotation else {
                Logger.log(.info, log: .map, "Can not focus on CM Annotation")
                return
            }
            self.focusOnCoordinate(cmAnnotation.coordinate, zoomArea: 1000)
        }
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

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveInitialLocation(notification:)), name: .initialGpsDataReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGPSDisabledOverlayVisibility), name: .observationModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveFocusNotification(notification:)), name: .focusLocation, object: nil)
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

    private func getNextRide(_ coordinate: CLLocationCoordinate2D) {
        nextRideManager.getNextRide(around: coordinate) { result in
            switch result {
            case let .success(ride):
                onMain { [unowned self] in
                    ride.flatMap { ride in
                        self.annotationController.first(where: { $0.annotationType == CriticalMassAnnotation.self })
                            .flatMap {
                                if #available(iOS 11.0, *) {
                                    guard let controller = $0 as? CMMarkerAnnotationController else {
                                        Logger.log(.debug, log: .map, "Controller expected to CMMarkerAnnotationController")
                                        return
                                    }
                                    controller.cmAnnotation = CriticalMassAnnotation(ride: ride)
                                } else {
                                    guard let controller = $0 as? CMAnnotationController else {
                                        Logger.log(.debug, log: .map, "Controller expected to CMAnnotationController")
                                        return
                                    }
                                    controller.cmAnnotation = CriticalMassAnnotation(ride: ride)
                                }
                            }
                        self.mapInfoViewController.presentMapInfo(title: ride.title, style: .info)
                    }
                }
            case let .failure(error):
                PrintErrorHandler().handleError(error)
            }
        }
    }

    @objc func didReceiveInitialLocation(notification: Notification) {
        guard let location = notification.object as? Location else { return }
        let coordinate = CLLocationCoordinate2D(location)
        focusOnCoordinate(coordinate)
        getNextRide(coordinate)
    }

    @objc func didReceiveFocusNotification(notification: Notification) {
        guard let location = notification.object as? Location else { return }
        focusOnCoordinate(CLLocationCoordinate2D(location), zoomArea: 1000)
    }

    private func focusOnCoordinate(
        _ coordinate: CLLocationCoordinate2D,
        zoomArea: Double = 10000,
        animated: Bool = true
    ) {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: zoomArea,
            longitudinalMeters: zoomArea
        )
        let adjustedRegion = mapView.regionThatFits(region)
        mapView.setRegion(adjustedRegion, animated: animated)
    }
}

extension MapViewController: MKMapViewDelegate {
    // MARK: MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKUserLocation == false else {
            return nil
        }

        guard annotation is CriticalMassAnnotation == false else {
            if #available(iOS 11.0, *) {
                if let cmAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CMMarkerAnnotationView.reuseIdentifier) {
                    cmAnnotationView.annotation = annotation
                    return cmAnnotationView
                } else {
                    return CMMarkerAnnotationView(annotation: annotation, reuseIdentifier: CMMarkerAnnotationView.reuseIdentifier)
                }
            } else {
                if let cmAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CMAnnotationView.reuseIdentifier) {
                    cmAnnotationView.annotation = annotation
                    return cmAnnotationView
                } else {
                    return CMAnnotationView(annotation: annotation, reuseIdentifier: CMAnnotationView.reuseIdentifier)
                }
            }
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
        guard let renderer = tileRenderer else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return renderer
    }
}
