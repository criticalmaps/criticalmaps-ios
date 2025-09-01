import MapKit
import UIKit

final class RiderAnnotationView: MKAnnotationView {
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
    
    configureView()
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    isAccessibilityElement = false
    
    registerForTraitChanges(
      [UITraitPreferredContentSizeCategory.self, UITraitUserInterfaceStyle.self],
      handler: { (self: Self, previousTraitCollection: UITraitCollection) in
        self.configureView()
      }
    )
  }
  
  private func configureView() {
    frame = defineFrame()
    layer.cornerRadius = frame.height / 2
    backgroundColor = UIColor.label.resolvedColor(with: traitCollection)
  }
  
  private func defineFrame() -> CGRect {
    switch traitCollection.preferredContentSizeCategory {
    case .extraSmall, .small, .medium, .large:
      .defaultSize
    case .extraLarge:
      .large
    case .extraExtraLarge:
      .extraLarge
    case .extraExtraExtraLarge,
         .accessibilityMedium,
         .accessibilityLarge,
         .accessibilityExtraLarge,
         .accessibilityExtraExtraLarge,
         .accessibilityExtraExtraExtraLarge:
      .extraExtraLarge
    default:
      .defaultSize
    }
  }
}

private extension CGRect {
  static let defaultSize = Self(x: 0, y: 0, width: 7, height: 7)
  static let large = Self(x: 0, y: 0, width: 10, height: 10)
  static let extraLarge = Self(x: 0, y: 0, width: 14, height: 14)
  static let extraExtraLarge = Self(x: 0, y: 0, width: 20, height: 20)
}
