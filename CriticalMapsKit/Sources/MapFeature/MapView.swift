import Foundation
import Logger
import MapKit
import NextRideFeature
import SharedModels
import Styleguide
import SwiftUI

public typealias ViewRepresentable = UIViewRepresentable

struct MapView: ViewRepresentable {
  typealias MenuActionHandle = () -> Void

  @Binding var userTrackingMode: MKUserTrackingMode
  @Binding var annotationsCount: Int?
  @Binding var centerRegion: CoordinateRegion?
  @Binding var centerEventRegion: CoordinateRegion?
  var riderCoordinates: [Rider]
  var nextRide: Ride?
  var rideEvents: [Ride] = []

  var mapMenuShareEventHandler: MenuActionHandle?
  var mapMenuRouteEventHandler: MenuActionHandle?

  init(
    riderCoordinates: [Rider],
    userTrackingMode: Binding<MKUserTrackingMode>,
    nextRide: Ride? = nil,
    rideEvents: [Ride] = [],
    annotationsCount: Binding<Int?>,
    centerRegion: Binding<CoordinateRegion?>,
    centerEventRegion: Binding<CoordinateRegion?>,
    mapMenuShareEventHandler: MapView.MenuActionHandle? = nil,
    mapMenuRouteEventHandler: MapView.MenuActionHandle? = nil
  ) {
    self.riderCoordinates = riderCoordinates
    _userTrackingMode = userTrackingMode
    self.nextRide = nextRide
    self.rideEvents = rideEvents
    _annotationsCount = annotationsCount
    _centerRegion = centerRegion
    _centerEventRegion = centerEventRegion
    self.mapMenuShareEventHandler = mapMenuShareEventHandler
    self.mapMenuRouteEventHandler = mapMenuRouteEventHandler
  }

  func makeCoordinator() -> MapCoordinator {
    MapCoordinator(self)
  }

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: UIScreen.main.bounds)
    mapView.mapType = .mutedStandard
    mapView.pointOfInterestFilter = .excludingAll
    mapView.delegate = context.coordinator
    mapView.showsUserLocation = true
    mapView.register(annotationViewType: RiderAnnoationView.self)
    mapView.register(annotationViewType: CMMarkerAnnotationView.self)
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context _: Context) {
    // rider handling
    centerRider(in: uiView)
    updateRiderAnnotations(in: uiView)

    // handle events
    setNextRideAnnotation(in: uiView)
    centerRideEvents(in: uiView)
    updateRideEvents(in: uiView)
  }

  func setNextRideAnnotation(in mapView: MKMapView) {
    if let nextRide {
      if mapView.annotations.compactMap({ $0 as? CriticalMassAnnotation }).isEmpty {
        let nextRideAnnotation = CriticalMassAnnotation(ride: nextRide)
        guard nextRide.coordinate != nil else { return }
        mapView.addAnnotation(nextRideAnnotation!)
      }
    }
  }

  func updateRiderAnnotations(in mapView: MKMapView) {
    let updatedAnnotations = RiderAnnotationUpdateClient.update(riderCoordinates, mapView)
    if !updatedAnnotations.removedAnnotations.isEmpty {
      mapView.removeAnnotations(updatedAnnotations.removedAnnotations)
    }
    if !updatedAnnotations.addedAnnotations.isEmpty {
      mapView.addAnnotations(updatedAnnotations.addedAnnotations)
    }
  }

  func centerRider(in mapView: MKMapView) {
    DispatchQueue.main.async {
      if let center = centerRegion {
        mapView.setRegion(center.asMKCoordinateRegion, animated: true)
        mapView.setUserTrackingMode(.none, animated: false)
      } else {
        mapView.setUserTrackingMode(userTrackingMode, animated: true)
      }
    }
  }

  func setRiderAnnotationsCount(_ mapView: MKMapView) {
    let riderAnnotations = mapView
      .annotations(in: mapView.visibleMapRect)
      .compactMap { $0 as? RiderAnnotation }
    annotationsCount = riderAnnotations.count
  }

  func centerRideEvents(in mapView: MKMapView) {
    if let eventCenter = centerEventRegion {
      var center = eventCenter
      center.center.latitude -= mapView.region.span.latitudeDelta * 0.20
      mapView.setRegion(center.asMKCoordinateRegion, animated: true)
    }
  }

  func updateRideEvents(in mapView: MKMapView) {
    if !rideEvents.isEmpty {
      let annotations = rideEvents.map { event in CriticalMassAnnotation(ride: event)! }
      for annotation in annotations {
        if mapView.annotations.contains(where: { a in a.title != annotation.title }) {
          mapView.addAnnotations(annotations)
        }
      }
    } else {
      for annotation in mapView.annotations {
        if let cmAnnotation = annotation as? CriticalMassAnnotation {
          if cmAnnotation.ride.id != nextRide?.id {
            mapView.removeAnnotation(annotation)
          }
        }
      }
    }
  }
}

/// Coordinator to handle MKMapViewDelegate events
final class MapCoordinator: NSObject, MKMapViewDelegate {
  var parent: MapView

  init(_ parent: MapView) {
    self.parent = parent
  }

  func mapView(_: MKMapView, didChange mode: MKUserTrackingMode, animated _: Bool) {
    parent.userTrackingMode = mode
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKUserLocation == false else {
      return nil
    }
    if annotation is RiderAnnotation {
      let view = mapView.dequeueReusableAnnotationView(
        withIdentifier: RiderAnnoationView.reuseIdentifier,
        for: annotation
      )
      return view
    }

    if annotation is CriticalMassAnnotation {
      let view = mapView.dequeueReusableAnnotationView(
        withIdentifier: CMMarkerAnnotationView.reuseIdentifier,
        for: annotation
      ) as? CMMarkerAnnotationView
      view?.shareEventClosure = parent.mapMenuShareEventHandler
      view?.routeEventClosure = parent.mapMenuRouteEventHandler
      return view
    }

    return MKAnnotationView()
  }

  func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    parent.setRiderAnnotationsCount(mapView)
  }
}
