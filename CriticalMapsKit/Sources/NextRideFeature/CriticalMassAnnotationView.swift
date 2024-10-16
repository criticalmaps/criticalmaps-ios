import L10n
import MapKit
import Styleguide

/// Map annotation view that displays the CM logo and offers a menu on long press.
public final class CMMarkerAnnotationView: MKMarkerAnnotationView {
  public typealias EventClosure = () -> Void
  
  public var shareEventClosure: EventClosure?
  public var routeEventClosure: EventClosure?
  
  override public func prepareForDisplay() {
    super.prepareForDisplay()
    commonInit()
  }
  
  private func commonInit() {
    animatesWhenAdded = true
    markerTintColor = .backgroundPrimary
    glyphImage = Asset.cmLogoM.image
    glyphTintColor = .textPrimary
    canShowCallout = false
    isAccessibilityElement = false
    
    let interaction = UIContextMenuInteraction(delegate: self)
    addInteraction(interaction)
  }
}

extension CMMarkerAnnotationView: UIContextMenuInteractionDelegate {
  public func contextMenuInteraction(
    _: UIContextMenuInteraction,
    configurationForMenuAtLocation _: CGPoint
  ) -> UIContextMenuConfiguration? {
    UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: { MapSnapshotViewController() },
      actionProvider: { _ in self.makeContextMenu() }
    )
  }
  
  private func makeContextMenu() -> UIMenu {
    let share = UIAction(
      title: L10n.Map.Menu.share,
      image: UIImage(systemName: "square.and.arrow.up")
    ) { _ in self.shareEventClosure?() }
    let route = UIAction(
      title: L10n.Map.Menu.route,
      image: UIImage(systemName: "arrow.turn.up.right")
    ) { _ in self.routeEventClosure?() }
    return UIMenu(
      title: L10n.Map.Menu.title,
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
      imageView.image = Asset.cmLogoC.image
      preferredContentSize = CGSize(width: 200, height: 150)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}
