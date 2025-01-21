import MapKit

extension MKAnnotationView {
  class var reuseIdentifier: String {
    String(describing: self)
  }
}

extension MKMapView {
  func register(annotationViewType: (some MKAnnotationView).Type) {
    register(
      annotationViewType,
      forAnnotationViewWithReuseIdentifier: annotationViewType.reuseIdentifier
    )
  }

  func dequeueReusableAnnotationView<T: MKAnnotationView>(
    ofType annotationType: T.Type,
    for _: IndexPath? = nil,
    with annotation: MKAnnotation
  ) -> T {
    let annotationView: T
    annotationView = dequeueReusableAnnotationView(
      withIdentifier: annotationType.reuseIdentifier,
      for: annotation
    ) as! T
    return annotationView
  }
}
