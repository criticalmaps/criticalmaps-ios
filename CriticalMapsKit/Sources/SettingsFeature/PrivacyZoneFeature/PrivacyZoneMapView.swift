import MapKit
import SharedModels
import SwiftUI

struct PrivacyZoneMapView: UIViewRepresentable {
  @Binding var zones: [PrivacyZone]
  @Binding var selectedZone: PrivacyZone?
  @Binding var isCreatingZone: Bool
  @Binding var newZoneRadius: Double
  @Binding var mapCenter: Coordinate?
  
  let showZones: Bool
  let onTapToCreateZone: (CLLocationCoordinate2D) -> Void
  
  func makeCoordinator() -> PrivacyZoneMapCoordinator {
    PrivacyZoneMapCoordinator(self)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.mapType = .mutedStandard
    mapView.pointOfInterestFilter = .excludingAll
    mapView.showsUserLocation = true
    
    // Add tap gesture for creating zones
    let tapGesture = UITapGestureRecognizer(
      target: context.coordinator,
      action: #selector(PrivacyZoneMapCoordinator.handleMapTap(_:))
    )
    mapView.addGestureRecognizer(tapGesture)
    
    return mapView
  }
  
  func updateUIView(_ mapView: MKMapView, context: Context) {
    context.coordinator.parent = self
    updateZoneOverlays(mapView)
    updateCreationPreview(mapView)
    updateZoomForCreation(mapView)
  }
  
  private func updateZoneOverlays(_ mapView: MKMapView) {
    // Remove existing overlays
    mapView.removeOverlays(mapView.overlays.filter { $0 is MKCircle })
    
    guard showZones else { return }
    
    // Add zone overlays
    for zone in zones where zone.isActive {
      mapView.addOverlay(zone.mkCircle)
    }
  }
  
  private func updateCreationPreview(_ mapView: MKMapView) {
    // Remove existing preview overlay
    mapView.removeOverlays(mapView.overlays.filter { $0.title == "preview" })
    
    guard isCreatingZone,
          let center = mapCenter else { return }
    
    let previewCircle = MKCircle(
      center: center.asCLLocationCoordinate,
      radius: newZoneRadius
    )
    previewCircle.title = "preview"
    mapView.addOverlay(previewCircle)
  }
  
  private func updateZoomForCreation(_ mapView: MKMapView) {
    guard isCreatingZone,
          let center = mapCenter else { return }
    
    // Calculate zoom radius based on the new zone radius
    let zoomRadius = newZoneRadius * 3 // Show area around the zone
    let region = MKCoordinateRegion(
      center: center.asCLLocationCoordinate,
      latitudinalMeters: zoomRadius,
      longitudinalMeters: zoomRadius
    )
    
    // Only animate if the region has changed significantly to avoid constant animation
    let currentRegion = mapView.region
    let centerDistance = CLLocation(
      latitude: currentRegion.center.latitude,
      longitude: currentRegion.center.longitude
    ).distance(from: CLLocation(
      latitude: region.center.latitude,
      longitude: region.center.longitude
    ))
    
    let spanDifference = abs(currentRegion.span.latitudeDelta - region.span.latitudeDelta)
    
    // Only update if there's a meaningful change
    if centerDistance > 10 || spanDifference > region.span.latitudeDelta * 0.1 {
      mapView.setRegion(region, animated: true)
    }
  }
}

class PrivacyZoneMapCoordinator: NSObject, MKMapViewDelegate {
  var parent: PrivacyZoneMapView
  
  init(_ parent: PrivacyZoneMapView) {
    self.parent = parent
    super.init()
  }
  
  @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
    guard parent.isCreatingZone else { return }
    
    let mapView = gesture.view as! MKMapView
    let location = gesture.location(in: mapView)
    let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
    
    parent.mapCenter = Coordinate(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude
    )
    
    parent.onTapToCreateZone(coordinate)
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let circle = overlay as? MKCircle else {
      return MKOverlayRenderer(overlay: overlay)
    }
    
    let renderer = MKCircleRenderer(circle: circle)
    
    if circle.title == "preview" {
      // Preview zone styling
      renderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.2)
      renderer.strokeColor = UIColor.systemBlue
      renderer.lineWidth = 2
      renderer.lineDashPattern = [5, 3]
    } else {
      // Regular privacy zone styling
      renderer.fillColor = UIColor.systemRed.withAlphaComponent(0.15)
      renderer.strokeColor = UIColor.systemRed
      renderer.lineWidth = 1.5
    }
    
    return renderer
  }
}
