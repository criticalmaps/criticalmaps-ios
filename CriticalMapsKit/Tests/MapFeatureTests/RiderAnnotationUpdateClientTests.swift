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
  func mapWithNoAnnoations_shouldAddAll_andRemoveNone() {
    let mapView = MKMapView()
    
    let updatedAnnotations = RiderAnnotationUpdateClient.update(rider, mapView)
    
    #expect(updatedAnnotations.addedAnnotations.count == 2)
    #expect(updatedAnnotations.removedAnnotations.isEmpty)
  }
  
  @Test
  func mapWithNoAnnoations_shouldAddSome_andRemoveNone() {
    let mapView = MKMapView()
    let annotations = rider.map(RiderAnnotation.init(rider:))
    mapView.addAnnotations(annotations)
    
    let newRiders = rider + updatedRiders
    let updatedAnnotations = RiderAnnotationUpdateClient.update(newRiders, mapView)
    
    #expect(updatedAnnotations.addedAnnotations.count == 2)
    #expect(updatedAnnotations.removedAnnotations.isEmpty)
  }
  
  @Test
  func mapWithNoAnnoations_shouldAdd2_andRemove2() {
    let mapView = MKMapView()
    let annotations = rider.map(RiderAnnotation.init(rider:))
    mapView.addAnnotations(annotations)
    
    let updatedAnnotations = RiderAnnotationUpdateClient.update(updatedRiders, mapView)
    
    #expect(updatedAnnotations.addedAnnotations.count == 2)
    #expect(updatedAnnotations.removedAnnotations.count == 2)
    
    let addedIds = updatedAnnotations.addedAnnotations.map(\.rider.id).sorted()
    #expect(addedIds == updatedRiders.map(\.id))

    let removedIds = updatedAnnotations.removedAnnotations.map(\.rider.id).sorted()
    #expect(removedIds == rider.map(\.id))
  }
  
  @Test
  func mapWithNoAnnoations_shouldAdd1_andRemove1() {
    let mapView = MKMapView()
    let newRiders = rider + [updatedRiders[1]]
    let annotations = newRiders.map(RiderAnnotation.init(rider:))
    mapView.addAnnotations(annotations)
    
    let updatedAnnotations = RiderAnnotationUpdateClient.update(rider + [updatedRiders[0]], mapView)
    
    #expect(updatedAnnotations.addedAnnotations.count == 1)
    #expect(updatedAnnotations.removedAnnotations.count == 1)
    
    let addedIds = updatedAnnotations.addedAnnotations.map(\.rider.id).sorted()
    #expect(addedIds == [updatedRiders[0]].map(\.id))
    
    let removedIds = updatedAnnotations.removedAnnotations.map(\.rider.id).sorted()
    #expect(removedIds == [updatedRiders[1]].map(\.id))
  }
}
