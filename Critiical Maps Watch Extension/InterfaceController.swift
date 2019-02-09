//
//  InterfaceController.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/8/19.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    @IBOutlet var map: WKInterfaceMap!
    lazy var locationManager: LocationManager = {
        LocationManager(updateInterval: 1)
    }()

    var currentZoomLevel: Double = 1
    var currentCoordinateOffset = CGPoint.zero
    var previousVisibleCoordinates: [Coordinate] = []

    let allCoordinates: [Coordinate] = {
        let path = Bundle.main.path(forResource: "testdata", ofType: "json")!
        let mockData = try! Data(contentsOf: URL(fileURLWithPath: path))
        let response = try! JSONDecoder().decode(ApiResponse.self, from: mockData)

        return response.locations.map {
            $0.value
        }.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
    }()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        Preferences.gpsEnabled = true
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

    func set(location _: Location, updatePins: Bool = true) {
        let fakeLocation = Location(longitude: 9.993682, latitude: 53.551086, timestamp: 0, name: nil, color: nil)

        let center = CLLocationCoordinate2D(latitude: fakeLocation.latitude, longitude: fakeLocation.longitude)

        var point = MKMapPoint(center)
        point.x -= Double(currentCoordinateOffset.x)
        point.y -= Double(currentCoordinateOffset.y)
        let size = MKMapSize(width: 1000 * currentZoomLevel, height: 1000 * currentZoomLevel)
        let mapRect = MKMapRect(origin: point, size: size)

        let visibleCoordinates = allCoordinates.filter { (coordinate) -> Bool in
            mapRect.contains(MKMapPoint(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)))
        }

        if updatePins {
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
