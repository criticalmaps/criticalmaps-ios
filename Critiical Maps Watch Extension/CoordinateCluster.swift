//
//  LocationCluster.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/8/19.
//

import Foundation

class CoordinateCluster {
    class Cluster {
        var centroid: Coordinate
        var elements: Set<Coordinate>

        init(centroid: Coordinate, elements: Set<Coordinate>) {
            self.centroid = centroid
            self.elements = elements
        }

        func average() -> Coordinate {
            let sum = elements.reduce((0, 0), ({ (result, location) -> (Double, Double) in
                (result.0 + location.latitude, result.1 + location.longitude)
            }))
            return Coordinate(latitude: sum.0 / Double(elements.count), longitude: sum.1 / Double(elements.count))
        }

        func median() -> Coordinate {
            let center = CoordinateBoundingBox.from(coordinates: elements).center
            let distances = elements.map { (center.distance(to: $0), $0) }
            let closestElementToCenter = distances.min { (a, b) -> Bool in
                a.0 < b.0
            }!.1
            return closestElementToCenter
        }
    }

    class func kMeans(for locations: Set<Coordinate>, numberOfCentroids: Int) -> [Cluster] {
        var cluster: [Cluster] = []
        cluster.reserveCapacity(numberOfCentroids)

        var remainingLocations = locations
        // Define initial centroids
        for _ in 0 ..< numberOfCentroids {
            guard let randomElement = remainingLocations.first else {
                continue
            }
            remainingLocations = Set(remainingLocations.dropFirst())
            cluster.append(Cluster(centroid: randomElement, elements: []))
        }

        var distanceChanged: Double = 100
        while distanceChanged > 0.00001 {
            distanceChanged = 0

            // empty elements for each centroid
            for c in cluster {
                c.elements = []
            }

            // assign location to the closest centroid
            for location in locations {
                let distances = cluster.map { (location.distance(to: $0.centroid), $0) }
                let closestCluster = distances.min { (a, b) -> Bool in
                    a.0 < b.0
                }
                closestCluster?.1.elements.insert(location)
            }

            // recalculate center of a cluster with the average of its element
            for c in cluster {
                let newCenter = c.average()
                if newCenter != c.centroid {
                    // we need the total distance, which has changed in this iteration, as termination criterion.
                    distanceChanged += newCenter.distance(to: c.centroid)
                    c.centroid = c.average()
                }
            }
        }

        return cluster
    }

    class func gridCluster(for coordinates: Set<Coordinate>, boundingBox: CoordinateBoundingBox) -> [Cluster] {
        guard coordinates.count > 1 else {
            if coordinates.isEmpty {
                return []
            }
            return [Cluster(centroid: coordinates.first!, elements: [coordinates.first!])]
        }

        // Generate possible Boxes that don't overlap
        let numberOfElements = 10
        let gridSizeX: Double = (boundingBox.bottomRight.latitude - boundingBox.topLeft.latitude) / Double(numberOfElements)
        let gridSizeY: Double = (boundingBox.bottomRight.longitude - boundingBox.topLeft.longitude) / Double(numberOfElements)
        var gridBoxes: [CoordinateBoundingBox] = []
        gridBoxes.reserveCapacity(numberOfElements * numberOfElements)

        var previousX = boundingBox.topLeft.latitude
        var previousY = boundingBox.topLeft.longitude
        for x in stride(from: boundingBox.topLeft.latitude, to: boundingBox.topRight.latitude, by: gridSizeX) {
            for y in stride(from: boundingBox.topLeft.longitude, to: boundingBox.bottomLeft.longitude, by: gridSizeY) {
                let minCoordinate = Coordinate(latitude: previousX, longitude: previousY)
                let maxCoordinate = Coordinate(latitude: x, longitude: y)
                let box = CoordinateBoundingBox(minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
                gridBoxes.append(box)

                previousY = y
            }
            previousX = x
        }

        // Get boxes that contain coordinates
        var unmatchedCoordinates = coordinates
        return gridBoxes.compactMap { (box) -> Cluster? in

            let matchedCoordinates = unmatchedCoordinates.filter(box.contains)
            if !matchedCoordinates.isEmpty {
                let result = Cluster(centroid: box.center, elements: matchedCoordinates)
                matchedCoordinates.forEach { unmatchedCoordinates.remove($0) }
                return result
            } else {
                return nil
            }
        }
    }

    class func gridAndKMeans(for locations: Set<Coordinate>, numberOfCentroids: Int, boundingBox: CoordinateBoundingBox) -> [Cluster] {
        let gridCluster = self.gridCluster(for: locations, boundingBox: boundingBox)
        let kMeans = self.kMeans(for: Set(gridCluster.map { $0.centroid }), numberOfCentroids: numberOfCentroids)
        // assign location to the closest centroid
        for location in locations {
            let distances = kMeans.map { (location.distance(to: $0.centroid), $0) }
            let closestCluster = distances.min { (a, b) -> Bool in
                a.0 < b.0
            }
            closestCluster?.1.elements.insert(location)
        }

        return kMeans
    }
}
