//
//  File.swift
//  
//
//  Created by Malte on 15.06.21.
//

import Foundation
import Logger
import MapKit
import NextRideFeature
import SharedModels
import Styleguide
import SwiftUI

public typealias ViewRepresentable = UIViewRepresentable

struct MapView: UIViewRepresentable {
  @Binding var riderCoordinates: [Rider]
  @Binding var userTrackingMode: MKUserTrackingMode
  
  func makeCoordinator() -> MapCoordinator {
    MapCoordinator(self)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.mapType = .standard
    mapView.pointOfInterestFilter = .excludingAll
    mapView.delegate = context.coordinator
    mapView.showsUserLocation = true
    mapView.register(annotationViewType: RiderAnnoationView.self)    
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.setUserTrackingMode(userTrackingMode, animated: true)
  
    // TODO: move set logic into reducer
    let currentlyDisplayedPOIs = uiView.annotations.compactMap { $0 as? RiderAnnotation }
      .map { $0.rider }
    
    let addedPOIs = Set(riderCoordinates).subtracting(currentlyDisplayedPOIs)
    let removedPOIs = Set(currentlyDisplayedPOIs).subtracting(riderCoordinates)
    
    let addedAnnotations = addedPOIs.map(RiderAnnotation.init(rider:))
    let removedAnnotations = uiView.annotations.compactMap { $0 as? RiderAnnotation }
      .filter { removedPOIs.contains($0.rider) }
    
    uiView.removeAnnotations(removedAnnotations)
    uiView.addAnnotations(addedAnnotations)
  }
}

public class MapCoordinator: NSObject, MKMapViewDelegate {
  var parent: MapView
  
  init(_ parent: MapView) {
    self.parent = parent
  }
    
  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKUserLocation == false else {
        return nil
    }
    if annotation is RiderAnnotation {
      let view = mapView.dequeueReusableAnnotationView(
        withIdentifier: RiderAnnoationView.reuseIdentifier,
        for: annotation
      )
      return view as! RiderAnnoationView
    }
    return MKAnnotationView()
  }
}
