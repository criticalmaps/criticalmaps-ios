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

#if os(macOS)
public typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
public typealias ViewRepresentable = UIViewRepresentable
#endif

public struct MapView: ViewRepresentable {
  @Binding var riderCoordinates: [Rider]
  @Binding var region: CoordinateRegion?
  @Binding var nextRide: Ride?
  
  public init(
    riderCoordinates: Binding<[Rider]>,
    region: Binding<CoordinateRegion?>,
    nextRide: Binding<Ride?>
  ) {
    self._riderCoordinates = riderCoordinates
    self._region = region
    self._nextRide = nextRide
  }
  
  #if os(macOS)
  public func makeNSView(context: Context) -> MKMapView {
    self.makeView(context: context)
  }
  #elseif os(iOS)
  public func makeUIView(context: Context) -> MKMapView {
    self.makeView(context: context)
  }
  #endif
  
  #if os(macOS)
  public func updateNSView(_ mapView: MKMapView, context: NSViewRepresentableContext<MapView>) {
    self.updateView(mapView: mapView, delegate: context.coordinator)
  }
  #elseif os(iOS)
  public func updateUIView(_ mapView: MKMapView, context: Context) {
    self.updateView(mapView: mapView, delegate: context.coordinator)
  }
  #endif
  
  public func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(self)
  }
  
  private func makeView(context: Context) -> MKMapView {
    let mapView = MKMapView(frame: .zero)
    mapView.showsUserLocation = true
    
    mapView.register(annotationViewType: RiderAnnoationView.self)
    
    return mapView
  }
  
  private func updateView(mapView: MKMapView, delegate: MKMapViewDelegate) {
    mapView.delegate = delegate
        
    // TODO: move set logic into reducer
    let currentlyDisplayedPOIs = mapView.annotations.compactMap { $0 as? RiderAnnotation }
      .map { $0.rider }
    
    let addedPOIs = Set(riderCoordinates).subtracting(currentlyDisplayedPOIs)
    let removedPOIs = Set(currentlyDisplayedPOIs).subtracting(riderCoordinates)
    
    let addedAnnotations = addedPOIs.map(RiderAnnotation.init(rider:))
    let removedAnnotations = mapView.annotations.compactMap { $0 as? RiderAnnotation }
      .filter { removedPOIs.contains($0.rider) }
    
    mapView.removeAnnotations(removedAnnotations)
    mapView.addAnnotations(addedAnnotations)
  }
}

public class MapViewCoordinator: NSObject, MKMapViewDelegate {
  var mapView: MapView
  
  init(_ control: MapView) {
    self.mapView = control
    super.init()
  }
  
  public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    self.mapView.region = CoordinateRegion(coordinateRegion: mapView.region)
  }
  
  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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

class CriticalMassAnnotation: NSObject, MKAnnotation {
  let ride: Ride
  let rideCoordinate: CLLocationCoordinate2D
  
  init?(ride: Ride) {
    guard let rideCoordinate = ride.coordinate else {
      return nil
    }
    self.rideCoordinate = rideCoordinate
    self.ride = ride
    super.init()
  }
  
  var title: String? {
    ride.titleAndTime
  }
  
  @objc dynamic var coordinate: CLLocationCoordinate2D {
    rideCoordinate
  }
  
  var subtitle: String? {
    ride.location
  }
}

open class CMMarkerAnnotationView: MKMarkerAnnotationView {
  typealias EventClosure = () -> Void
  
  var shareEventClosure: EventClosure?
  var routeEventClosure: EventClosure?
  
  open override func prepareForDisplay() {
    super.prepareForDisplay()
    commonInit()
  }
  
  private func commonInit() {
    animatesWhenAdded = true
    markerTintColor = .white
    //        glyphImage = Asset.logoM.image
    canShowCallout = false
    
    if #available(iOS 13.0, *) {
      let interaction = UIContextMenuInteraction(delegate: self)
      addInteraction(interaction)
    }
  }
}

@available(iOS 13.0, *)
extension CMMarkerAnnotationView: UIContextMenuInteractionDelegate {
  public func contextMenuInteraction(_: UIContextMenuInteraction, configurationForMenuAtLocation _: CGPoint) -> UIContextMenuConfiguration? {
    UIContextMenuConfiguration(identifier: nil, previewProvider: { MapSnapshotViewController() }) { _ in
      self.makeContextMenu()
    }
  }
  
  private func makeContextMenu() -> UIMenu {
    let share = UIAction(
      title: "L10n.Map.Menu.share",
      image: UIImage(systemName: "square.and.arrow.up")
    ) { _ in
      self.shareEventClosure?()
    }
    let route = UIAction(
      title: "L10n.Map.Menu.route",
      image: UIImage(systemName: "arrow.turn.up.right")
    ) { _ in
      self.routeEventClosure?()
    }
    return UIMenu(
      title: "L10n.Map.Menu.title",
      children: [share, route]
    )
  }
  
  class MapSnapshotViewController: UIViewController {
    private let imageView = UIImageView()
    
    override func loadView() {
      view = imageView
    }
    
    init() {
      super.init(nibName: nil, bundle: nil)
      imageView.backgroundColor = .clear
      imageView.clipsToBounds = true
      imageView.contentMode = .scaleAspectFit
      //            imageView.image = Asset.eventMarker.image
      preferredContentSize = CGSize(width: 200, height: 150)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

class CMAnnotationView: MKAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    //        image = Asset.eventMarker.image
    canShowCallout = true
  }
}
