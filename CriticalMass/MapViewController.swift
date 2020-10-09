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
    private lazy var annotationControllers: [AnnotationController] = {
        [BikeAnnotationController(mapView: self.mapView), CMMarkerAnnotationController(mapView: self.mapView)]
    }()

    private let nightThemeOverlay = DarkModeMapOverlay()
    public lazy var followMeButton: UserTrackingButton = {
        UserTrackingButton(mapView: mapView)
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

    private let statusBarBlurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIApplication.shared.statusBarHeight()
        )
        return view
    }()

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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.mapTitle
        configureNotifications()
        configureTileRenderer()
        configureMapView()
        condfigureGPSDisabledOverlayView()
        registerAnnotationViews()
        setupMapInfoViewController()

        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if #available(iOS 13.0, *) {
            view.window?.windowScene?.screenshotService?.delegate = self
        }
    }

    private func registerAnnotationViews() {
        annotationControllers
            .map(\.annotationViewType)
            .forEach(mapView.register)
    }

    private func setupMapInfoViewController() {
        add(mapInfoViewController)
        mapInfoViewController.view.addLayoutsSameSizeAndOrigin(in: view)
        mapInfoViewController.tapHandler = { [unowned self] in
            self.nextRideManager.nextRide.flatMap { self.focusOnCoordinate($0.coordinate) }
        }
    }

    private func condfigureGPSDisabledOverlayView() {
        let gpsDisabledOverlayView = self.gpsDisabledOverlayView
        gpsDisabledOverlayView.set(title: L10n.mapLayerInfoTitle, message: L10n.mapLayerInfo)
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if themeController.currentTheme == .system, previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            themeController.applyTheme()
        }
    }

    private func configureMapView() {
        view.addSubview(mapView)
        mapView.addLayoutsSameSizeAndOrigin(in: view)
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
        mapView.showsUserLocation = true

        view.addSubview(statusBarBlurView)
    }

    @objc func didTapGPSDisabledOverlayButton() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

    @objc func updateGPSDisabledOverlayVisibility() {
        gpsDisabledOverlayView.isHidden = LocationManager.accessPermission != .denied
    }

    // MARK: Theme
    override var preferredStatusBarStyle: UIStatusBarStyle {
        themeController.currentTheme.style.statusBarStyle
    }

    @objc private func themeDidChange() {
        setMapTheme()
    }

    private func configureTileRenderer() {
        setMapTheme()
    }

    private func setMapTheme() {
        switch themeController.currentTheme {
        case .system:
            if #available(iOS 13.0, *) {
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    overrideUserInterfaceStyle = .dark
                case .light:
                    overrideUserInterfaceStyle = .light
                case .unspecified:
                    overrideUserInterfaceStyle = .unspecified
                @unknown default:
                    overrideUserInterfaceStyle = .light
                }
            }
        case .light:
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
            } else {
                removeTileRenderer()
            }
        case .dark:
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .dark
            } else {
                addTileRenderer()
            }
        case .none:
            break
        }
    }

    @available(iOS, deprecated: 12, message: "Not to be used from iOS 13")
    private func removeTileRenderer() {
        tileRenderer = nil
        mapView.removeOverlay(nightThemeOverlay)
    }

    @available(iOS, deprecated: 12, message: "Not to be used from iOS 13")
    private func addTileRenderer() {
        tileRenderer = MKTileOverlayRenderer(tileOverlay: nightThemeOverlay)
        mapView.addOverlay(nightThemeOverlay, level: .aboveRoads)
    }

    private func getNextRide(_ coordinate: CLLocationCoordinate2D) {
        guard Feature.events.isActive else {
            return
        }
        nextRideManager.getNextRide(around: coordinate) { result in
            switch result {
            case let .success(ride):
                onMain { [unowned self] in
                    self.annotationControllers.first(where: { $0.annotationType == CriticalMassAnnotation.self })
                        .flatMap {
                            guard let controller = $0 as? CMMarkerAnnotationController else {
                                Logger.log(.debug, log: .map, "Controller expected to CMMarkerAnnotationController")
                                return
                            }
                            controller.update([CriticalMassAnnotation(ride: ride)])
                        }
                    self.mapInfoViewController.configureAndPresentMapInfoView(
                        title: ride.titleAndTime,
                        style: .info
                    )
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
        focusOnCoordinate(CLLocationCoordinate2D(location))
    }

    private func focusOnCoordinate(
        _ coordinate: CLLocationCoordinate2D,
        zoomArea: Double = 1000,
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

        guard let matchingController = annotationControllers.first(where: { type(of: annotation) == $0.annotationType }) else {
            return nil
        }

        // TODO: Remove workaround when target > iOS10 since it does not seem to work with the MKMapView+Register extension
        if annotation is CriticalMassAnnotation {
            let view = mapView.dequeueReusableAnnotationView(
                withIdentifier: CMMarkerAnnotationView.reuseIdentifier,
                for: annotation
            )
            let markerView = view as! CMMarkerAnnotationView
            markerView.shareEventClosure = { self.shareEvent() }
            markerView.routeEventClosure = { self.routeToEvent() }
            return view
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

    // MARK: Menu interaction handling

    func mapView(_: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is CriticalMassAnnotation {
            let longTapGestureRecognizer = UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleEventLongPress(_:))
            )
            view.addGestureRecognizer(longTapGestureRecognizer)
        }
    }

    @objc private func handleEventLongPress(_: Any) {
        let routeAction = UIAlertAction(title: L10n.menuRoute, style: .default) { _ in self.routeToEvent() }
        let shareAction = UIAlertAction(title: L10n.menuShare, style: .default) { _ in self.shareEvent() }
        AlertPresenter.shared.presentAlert(
            title: L10n.menuTitle,
            preferredStyle: .actionSheet,
            actionData: [routeAction, shareAction],
            isCancelable: true
        )
    }

    private func routeToEvent() {
        nextRideManager.nextRide?.openInMaps()
    }

    private func shareEvent() {
        nextRideManager.nextRide.flatMap {
            let activityViewController = UIActivityViewController(
                activityItems: [$0.shareMessage],
                applicationActivities: nil
            )
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension MapViewController: UIScreenshotServiceDelegate {
    @available(iOS 13.0, *)
    func screenshotService(_: UIScreenshotService, generatePDFRepresentationWithCompletion completionHandler: @escaping (Data?, Int, CGRect) -> Void) {
        let data = UIGraphicsPDFRenderer(bounds: view.bounds).pdfData { context in
            context.beginPage()

            self.mapView.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        }
        completionHandler(data, 0, view.bounds)
    }
}
