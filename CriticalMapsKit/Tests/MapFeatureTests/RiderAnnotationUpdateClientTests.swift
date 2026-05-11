import Combine
import ComposableArchitecture
import Foundation
import MapFeature
import MapKit
import SharedModels
import Testing

let fixedDate: @Sendable () -> Date = { Date(timeIntervalSinceReferenceDate: 0) }

@MainActor
struct RiderAnnotationUpdateClientTests {  
  let rider = [
    Rider(
      id: "SomeRandomID",
      location: .init(
        coordinate: .init(
          latitude: 13.13,
          longitude: 52.52
        ),
        timestamp: fixedDate().timeIntervalSinceReferenceDate,
        name: nil,
        color: nil
      )
    ),
    Rider(
      id: "SomeRandomID2",
      location: .init(
        coordinate: .init(
          latitude: 13.12,
          longitude: 52.51
        ),
        timestamp: fixedDate().timeIntervalSinceReferenceDate,
        name: nil,
        color: nil
      )
    )
  ]
  let updatedRiders = [
    Rider(
      id: "SomeRandomID3",
      location: .init(
        coordinate: .init(
          latitude: 13.13,
          longitude: 52.52
        ),
        timestamp: fixedDate().timeIntervalSinceReferenceDate,
        name: nil,
        color: nil
      )
    ),
    Rider(
      id: "SomeRandomID4",
      location: .init(
        coordinate: .init(
          latitude: 13.12,
          longitude: 52.51
        ),
        timestamp: fixedDate().timeIntervalSinceReferenceDate,
        name: nil,
        color: nil
      )
    )
  ]
  
  @Test
  func `map with no annotations should add all and remove none`() {
    let mapView = MKMapView()
    
    let updatedAnnotations = RiderAnnotationUpdateClient.update(
      rider,
      mapView,
      showActiveRidersOnly: false
    )
    
    #expect(updatedAnnotations.addedAnnotations.count == 2)
    #expect(updatedAnnotations.removedAnnotations.isEmpty)
  }
  
  @Test
  func `map with no annotations should add some and remove none`() {
    let mapView = MKMapView()
    let annotations = rider.map { RiderAnnotation(rider: $0) }
    mapView.addAnnotations(annotations)
    
    let newRiders = rider + updatedRiders
    let updatedAnnotations = RiderAnnotationUpdateClient.update(
      newRiders,
      mapView,
      showActiveRidersOnly: false
    )
    
    #expect(updatedAnnotations.addedAnnotations.count == 2)
    #expect(updatedAnnotations.removedAnnotations.isEmpty)
  }
  
  @Test
  func `map with no annotations should add 2 and remove 2`() {
    let mapView = MKMapView()
    let annotations = rider.map { RiderAnnotation(rider: $0) }
    mapView.addAnnotations(annotations)
    
    let updatedAnnotations = RiderAnnotationUpdateClient.update(
      updatedRiders,
      mapView,
      showActiveRidersOnly: false
    )
    
    #expect(updatedAnnotations.addedAnnotations.count == 2)
    #expect(updatedAnnotations.removedAnnotations.count == 2)
    
    let addedIds = updatedAnnotations.addedAnnotations.map(\.rider.id).sorted()
    #expect(addedIds == updatedRiders.map(\.id))

    let removedIds = updatedAnnotations.removedAnnotations.map(\.rider.id).sorted()
    #expect(removedIds == rider.map(\.id))
  }
  
  @Test
  func `map with no annotations should add 1 and remove 1`() {
    let mapView = MKMapView()
    let newRiders = rider + [updatedRiders[1]]
    let annotations = newRiders.map { RiderAnnotation(rider: $0) }
    mapView.addAnnotations(annotations)
    
    let updatedAnnotations = RiderAnnotationUpdateClient.update(
      rider + [updatedRiders[0]],
      mapView,
      showActiveRidersOnly: false
    )
    
    #expect(updatedAnnotations.addedAnnotations.count == 1)
    #expect(updatedAnnotations.removedAnnotations.count == 1)
    
    let addedIds = updatedAnnotations.addedAnnotations.map(\.rider.id).sorted()
    #expect(addedIds == [updatedRiders[0]].map(\.id))
    
    let removedIds = updatedAnnotations.removedAnnotations.map(\.rider.id).sorted()
    #expect(removedIds == [updatedRiders[1]].map(\.id))
  }
	
  @Test
  func `Added annotations are stamped with correct isActive from classification`() {
    let mapView = MKMapView()

    // Tight cluster of 4 — all should be active
    let clusterRiders = (0 ..< 4).map { i in
      Rider(
        id: "rider-\(i)",
        location: .init(
          coordinate: Coordinate(
            latitude: 52.520 + Double(i) * 0.0005,
            longitude: 13.405
          ),
          timestamp: fixedDate().timeIntervalSinceReferenceDate
        )
      )
    }

    let result = RiderAnnotationUpdateClient.update(
      clusterRiders,
      mapView,
      showActiveRidersOnly: false
    )

    #expect(result.addedAnnotations.count == 4)
		
    let allSatisfyIsActive = result.addedAnnotations.allSatisfy(\.isActive)
    #expect(allSatisfyIsActive)
  }

  @Test
  func `Isolated added rider is stamped as inactive`() {
    let mapView = MKMapView()

    let loneRider = Rider(
      id: "lone",
      location: .init(
        coordinate: Coordinate(latitude: 52.520, longitude: 13.405),
        timestamp: fixedDate().timeIntervalSinceReferenceDate
      )
    )

    let result = RiderAnnotationUpdateClient.update(
      [loneRider],
      mapView,
      showActiveRidersOnly: false
    )

    #expect(result.addedAnnotations.count == 1)
    #expect(result.addedAnnotations.first?.isActive == false)
  }

  @Test
  func `Active state reflects full rider set, not just added riders`() {
    let mapView = MKMapView()

    // 3 already on map — they form a cluster with the 1 new rider
    let existingRiders = (0 ..< 3).map { i in
      Rider(
        id: "existing-\(i)",
        location: .init(
          coordinate: Coordinate(
            latitude: 52.520 + Double(i) * 0.0005,
            longitude: 13.405
          ),
          timestamp: fixedDate().timeIntervalSinceReferenceDate
        )
      )
    }
    mapView.addAnnotations(existingRiders.map { RiderAnnotation(rider: $0) })

    let newRider = Rider(
      id: "new",
      location: .init(
        coordinate: Coordinate(latitude: 52.5215, longitude: 13.405),
        timestamp: fixedDate().timeIntervalSinceReferenceDate
      )
    )

    let result = RiderAnnotationUpdateClient.update(
      existingRiders + [newRider],
      mapView,
      showActiveRidersOnly: false
    )

    // New rider joins the cluster — should be active
    #expect(result.addedAnnotations.first?.isActive == true)
  }
}
