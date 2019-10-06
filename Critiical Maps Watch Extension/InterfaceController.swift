//
//  InterfaceController.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/8/19.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    let useMockData = true
    @IBOutlet var map: WKInterfaceMap!
    lazy var locationManager: LocationManager = {
        LocationManager(updateInterval: 1)
    }()

    let dataStore = MemoryDataStore()
    lazy var requestManager: RequestManager = {
        RequestManager(dataStore: dataStore, locationProvider: locationManager, networkLayer: NetworkOperator(networkIndicatorHelper: NetworkActivityIndicatorHelper()), idProvider: IDStore(), url: Constants.apiEndpoint)
    }()

    var currentZoomLevel: Double = 1
    var currentCoordinateOffset = CGPoint.zero
    var previousVisibleCoordinates: [Coordinate] = []

    let mockCoordinates: [Coordinate] = {
        let path = Bundle.main.path(forResource: "testdata", ofType: "json")!
        let mockData = try! Data(contentsOf: URL(fileURLWithPath: path))
        let response = try! JSONDecoder().decode(ApiResponse.self, from: mockData)

        return response.locations.map {
            $0.value
        }.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
    }()

    var currentCoordinates: [Coordinate] {
        if useMockData {
            return mockCoordinates
        } else {
            return dataStore.lastKnownResponse?.locations.map { Coordinate(latitude: $0.value.latitude, longitude: $0.value.longitude) } ?? []
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        NotificationCenter.default.addObserver(self, selector: #selector(positionsDidChange(notification:)), name: NSNotification.Name("positionOthersChanged"), object: nil)

        crownSequencer.delegate = self
    }

    override func didAppear() {
        super.didAppear()
        crownSequencer.focus()
        
        
        locationManager.updateLocationCallback = { location in
            self.set(location: location)
        }
    }

    func present(cluster: [CoordinateCluster.Cluster]) {
        map.removeAllAnnotations()
        for c in cluster {
            let coordinate = c.centroid
            let location = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let image = AnnotationRenderer(numberOfElements: c.elements.count, size: CGSize(width: 22, height: 22)).image
            map.addAnnotation(location, with: image, centerOffset: .zero)
        }
    }

    func set(location: Location, updatePins: Bool = true) {
        let center: CLLocationCoordinate2D

        if useMockData {
            let fakeLocation = Location(longitude: 9.993682, latitude: 53.551086, timestamp: 0, name: nil, color: nil)
            center = CLLocationCoordinate2D(latitude: fakeLocation.latitude, longitude: fakeLocation.longitude)
        } else {
            center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }

        var point = MKMapPoint(center)
        point.x -= Double(currentCoordinateOffset.x)
        point.y -= Double(currentCoordinateOffset.y)
        let size = MKMapSize(width: 1000 * currentZoomLevel, height: 1000 * currentZoomLevel)
        let mapRect = MKMapRect(origin: point, size: size)

        if updatePins {
            let visibleCoordinates = currentCoordinates.filter { (coordinate) -> Bool in
                mapRect.contains(MKMapPoint(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)))
            }
            if visibleCoordinates != previousVisibleCoordinates {
                // We are using a combination of grid and k-means clustering to first identify cluster points
                // that don't overlap each other with grid clustering and second reducing
                // the amount of clusters to 5 (the maximum amount of annotations on Apple Watch)
                // if needed with the k-means algorithm
                let cluster = CoordinateCluster.gridAndKMeans(for: Set(visibleCoordinates), numberOfCentroids: 5, boundingBox: CoordinateBoundingBox.from(mapRect: mapRect))
                present(cluster: cluster)
                previousVisibleCoordinates = visibleCoordinates
            }
        }

        map.setVisibleMapRect(mapRect)
    }

    @IBAction func handleGesture(gestureRecognizer: WKPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInObject()
        currentCoordinateOffset.x += translation.x * CGFloat(currentZoomLevel)
        currentCoordinateOffset.y += translation.y * CGFloat(currentZoomLevel)
        if let location = locationManager.currentLocation {
            set(location: location, updatePins: gestureRecognizer.state == .ended)
        }
    }

    @objc private func positionsDidChange(notification _: Notification) {
        if let location = locationManager.currentLocation {
            set(location: location)
        }
    }

    // WKCrownDelegate

    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        currentZoomLevel += rotationalDelta * (abs(crownSequencer?.rotationsPerSecond ?? 1)) * currentZoomLevel
        if let location = locationManager.currentLocation {
            set(location: location, updatePins: false)
        }
    }

    func crownDidBecomeIdle(_: WKCrownSequencer?) {
        if let location = locationManager.currentLocation {
            set(location: location)
        }
    }
}
