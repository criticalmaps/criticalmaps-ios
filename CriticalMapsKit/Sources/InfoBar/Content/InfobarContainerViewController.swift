import Combine
import UIKit
import SwiftUI

public final class InfobarContainerViewController: UIViewController, StatusbarStyleProvider {
  private lazy var _statusbarStyleProviderStateSubject = CurrentValueSubject<
    StatusbarStyleProviderState,
    Never
  >(self.statusbarStyleProviderState)
  
  public init(rootViewController: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = .systemBackground
    
    addChild(rootViewController)
    view.addSubview(rootViewController.view)
    rootViewController.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: 200, right: 0)
    rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
    rootViewController.view.backgroundColor = .clear
    NSLayoutConstraint.activate(
      [
        rootViewController.view.topAnchor.constraint(
          equalTo: view.topAnchor
        ),
        rootViewController.view.leadingAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.leadingAnchor
        ),
        rootViewController.view.trailingAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.trailingAnchor
        ),
        rootViewController.view.bottomAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.bottomAnchor
        )
      ]
    )
    rootViewController.didMove(toParent: self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public var statusbarStylePublisher: AnyPublisher<StatusbarStyleProviderState, Never> {
    _statusbarStyleProviderStateSubject
      .removeDuplicates()
      .eraseToAnyPublisher()
  }
  
  public override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    super.present(
      viewControllerToPresent,
      animated: flag,
      completion: { [weak self] in
        completion?()
        self?.publishStatusbarStyleProviderState()
      }
    )
  }
  
  public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(
      animated: flag,
      completion: { [weak self] in
        completion?()
        self?.publishStatusbarStyleProviderState()
      }
    )
  }
  
  public override func setNeedsStatusBarAppearanceUpdate() {
    super.setNeedsStatusBarAppearanceUpdate()
    publishStatusbarStyleProviderState()
  }
  
  private func publishStatusbarStyleProviderState() {
    _statusbarStyleProviderStateSubject.send(statusbarStyleProviderState)
  }
  
  public var statusbarStyleProviderState: StatusbarStyleProviderState {
    let activeViewController = self.presentedViewController
    ?? children.compactMap { $0 as? UINavigationController }.first?.topViewController
    ?? self
    
    let isPresentingModalSheet = presentedViewController?.modalPresentationStyle == .some(.pageSheet)
    
    return StatusbarStyleProviderState(
      isPresentingModalSheet: isPresentingModalSheet,
      userInterfaceStyle: activeViewController.traitCollection.userInterfaceStyle,
      activeViewController: activeViewController
    )
  }
}
