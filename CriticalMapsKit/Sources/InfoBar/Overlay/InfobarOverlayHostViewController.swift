import Combine
import ComposableArchitecture
import UIKit
import SwiftUI

public class InfobarOverlayHostViewController: UIViewController {
  private var cancellables = Set<AnyCancellable>()
  private var statusbarObservation: AnyCancellable?
  
  public weak var statusbarStyleProvider: StatusbarStyleProvider? {
    didSet {
      statusbarObservation = statusbarStyleProvider?
        .statusbarStylePublisher
        .removeDuplicates()
        .sink { [weak self] value in
          self?.statusbarStyle = value
          self?._childForStatusBarHidden = value.activeViewController
          self?.setNeedsStatusBarAppearanceUpdate()
        }
    }
  }
  
  private var statusbarStyle: StatusbarStyleProviderState?
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    guard let statusbarStyle = statusbarStyle else {
      return .default
    }
    
    switch (statusbarStyle.userInterfaceStyle, statusbarStyle.isPresentingModalSheet) {
    case (.light, true), (.unspecified, true), (.dark, _):
      return .lightContent
    case (.light, false), (.unspecified, false):
      return .darkContent
    case (_, _):
      return .default
    }
  }
  
  public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    .fade
  }
  
  private weak var _childForStatusBarHidden: UIViewController?
  public override var childForStatusBarHidden: UIViewController? {
    _childForStatusBarHidden
  }
  
  init(
    infobarController: InfobarController,
    passthroughTag: Int
  ) {
    super.init(nibName: nil, bundle: nil)
    
    let hostingController = UIHostingController(
      rootView: InfobarOverlay(
        store: infobarController.store
      )
    )
    
    view.addSubview(hostingController.view)
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    hostingController.view.backgroundColor = .clear
    NSLayoutConstraint.activate(
      [
        hostingController.view.topAnchor.constraint(
          equalTo: view.topAnchor
        ),
        hostingController.view.leadingAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.leadingAnchor
        ),
        hostingController.view.trailingAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.trailingAnchor
        ),
        hostingController.view.bottomAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
      ]
    )
    
    hostingController.didMove(toParent: self)
    hostingController.view.tag = passthroughTag
    view.tag = passthroughTag
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
