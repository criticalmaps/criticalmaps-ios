import MapKit
import UIKit

final class RiderAnnoationView: MKAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    canShowCallout = false
    backgroundColor = UIColor.label.resolvedColor(with: traitCollection)
    
    frame = defineFrame()
    layer.cornerRadius = frame.height / 2
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  private func defineFrame() -> CGRect {
    switch traitCollection.preferredContentSizeCategory {
    case .extraSmall, .small, .medium, .large:
      return .defaultSize
    case .extraLarge:
      return .large
    case .extraExtraLarge:
      return .extraLarge
    case .extraExtraExtraLarge,
        .accessibilityMedium,
        .accessibilityLarge,
        .accessibilityExtraLarge,
        .accessibilityExtraExtraLarge,
        .accessibilityExtraExtraExtraLarge:
      return .extraExtraLarge
    default:
      return .defaultSize
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    // For some reason when this active the annotions disappear when sheets dismiss
//    frame = defineFrame()
//    layer.cornerRadius = frame.height / 2
    backgroundColor = UIColor.label.resolvedColor(with: traitCollection)
    setNeedsDisplay()
  }
}

extension CGRect {
  static let defaultSize = Self(x: 0, y: 0, width: 7, height: 7)
  static let large = Self(x: 0, y: 0, width: 10, height: 10)
  static let extraLarge = Self(x: 0, y: 0, width: 14, height: 14)
  static let extraExtraLarge = Self(x: 0, y: 0, width: 20, height: 20)
}
