import MapKit
import UIKit

final class RiderAnnotationView: MKAnnotationView {
  // MARK: - State

  /// Whether active-group highlighting is enabled (the `highlightActiveRiders`
  /// setting). When ON, riders in an active group are highlighted red; when OFF,
  /// all riders are shown in neutral gray.
  var highlightActiveRiders = false {
    didSet {
      guard oldValue != highlightActiveRiders else { return }
      updateAppearance(animated: true)
    }
  }
	
  var isRiderActive = false {
    didSet {
      guard oldValue != isRiderActive else { return }
      updateAppearance(animated: true)
    }
  }

  // MARK: - Init

  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  // MARK: - Setup

  private func commonInit() {
    canShowCallout = false
		
    configureView()

    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    isAccessibilityElement = false

    registerForTraitChanges(
      [UITraitPreferredContentSizeCategory.self, UITraitUserInterfaceStyle.self],
      handler: { (self: Self, _: UITraitCollection) in
        self.configureView()
      }
    )
  }

  private func configureView() {
    let dotFrame = defineFrame()
    frame = dotFrame
    layer.cornerRadius = dotFrame.height / 2
    updateAppearance(animated: false)
  }

  private func updateAppearance(animated: Bool) {
    // Only highlight a rider as part of an active group when the toggle is on.
    // With the toggle off no rider is highlighted (all neutral gray).
    let highlightAsActive = isRiderActive && highlightActiveRiders

    let targetColor: UIColor = highlightAsActive
      ? .brand500
      : highlightAsActive ? .systemGray : .label

    let targetScale: CGFloat = highlightAsActive ? 1.0 : 0.75

    let applyChanges = {
      self.backgroundColor = targetColor.resolvedColor(with: self.traitCollection)
      self.transform = CGAffineTransform(scaleX: targetScale, y: targetScale)
    }

    // Only animate changes for a view that's already on-screen. While a view is
    // being configured before display (no window yet), apply instantly so newly
    // added annotations render in their final color rather than fading in from gray.
    if animated, window != nil {
      UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut]) {
        applyChanges()
      }
    } else {
      applyChanges()
    }
  }

  // MARK: - Frame

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

// MARK: - CGRect sizes

private extension CGRect {
  static let defaultSize = Self(x: 0, y: 0, width: 7, height: 7)
  static let large = Self(x: 0, y: 0, width: 10, height: 10)
  static let extraLarge = Self(x: 0, y: 0, width: 14, height: 14)
  static let extraExtraLarge = Self(x: 0, y: 0, width: 20, height: 20)
}
