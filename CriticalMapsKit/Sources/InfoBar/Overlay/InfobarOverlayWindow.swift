import Combine
import ComposableArchitecture
import UIKit
import SwiftUI

public final class InfobarOverlayWindow: PassthroughWindow {
  private weak var infobarViewController: InfobarOverlayHostViewController?
  private var cancellables = Set<AnyCancellable>()
  
  public weak var statusbarStyleProvider: StatusbarStyleProvider? {
    didSet {
      infobarViewController?.statusbarStyleProvider = statusbarStyleProvider
    }
  }
  
  public init(
    frame: CGRect,
    infobarController: InfobarController
  ) {
    super.init(frame: frame)
    setup(infobarController)
  }
  
  public init(
    windowScene: UIWindowScene,
    infobarController: InfobarController
  ) {
    super.init(windowScene: windowScene)
    setup(infobarController)
  }
  
  fileprivate func setup(_ infobarController: InfobarController) {
    let infobarViewController = InfobarOverlayHostViewController(
      infobarController: infobarController,
      passthroughTag: passthroughTag
    )
    self.rootViewController = infobarViewController
    self.infobarViewController = infobarViewController
    
    windowLevel = .statusBar + 1
    
    let viewStore = ViewStore(infobarController.store)
    
    viewStore
      .publisher
      .shouldShowOverlay
      .sink { [weak self] shouldShowOverlay in
        self?.isHidden = !shouldShowOverlay
      }
      .store(in: &cancellables)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
