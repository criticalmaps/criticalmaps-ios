//
//  File.swift
//  
//
//  Created by Malte on 26.06.21.
//

import MapKit

open class CMMarkerAnnotationView: MKMarkerAnnotationView {
  typealias EventClosure = () -> Void
  
  // Replace with Bindings
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
    
    let interaction = UIContextMenuInteraction(delegate: self)
    addInteraction(interaction)
  }
}

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

open class CMAnnotationView: MKAnnotationView {
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    //        image = Asset.eventMarker.image
    canShowCallout = true
  }
}

