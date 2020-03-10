//
//  NavigationOverlayViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/3/19.
//

import UIKit

class SeparatorView: UIView {}
class OverlayView: UIView {
    @objc
    dynamic var overlayBackgroundColor: UIColor? {
        willSet {
            backgroundColor = newValue
        }
    }
}

struct NavigationOverlayItem {
    enum Action {
        case navigation(viewController: () -> UIViewController)
        case none
    }

    enum Representation {
        case icon(_ icon: UIImage, accessibilityLabel: String)
        case view(_ view: UIView)
        case button(_ button: UIButton)
    }

    let representation: Representation
    let action: Action
    let accessibilityIdentifier: String
}

class NavigationOverlayViewController: UIViewController {
    private var items: [NavigationOverlayItem]
    private var itemViews: [UIView] = []
    private var separatorViews: [SeparatorView] = []

    init(navigationItems: [NavigationOverlayItem]) {
        items = navigationItems
        super.init(nibName: nil, bundle: nil)
        configure(items: navigationItems)
    }

    override func loadView() {
        super.loadView()
        view = OverlayView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewBackground()
    }

    private func configureViewBackground() {
        view.insertSubview(visualEffectView, at: 0)
        view.layer.setupMapOverlayConfiguration()
        view.accessibilityTraits.insert(.tabBar)
    }

    private func configure(items: [NavigationOverlayItem]) {
        for (index, item) in items.enumerated() {
            switch item.representation {
            case let .icon(icon, accessibilityLabel: accessibilityLabel):
                let button = CustomButton(frame: .zero)
                button.setImage(icon, for: .normal)
                button.adjustsImageWhenHighlighted = false
                button.accessibilityLabel = accessibilityLabel
                button.accessibilityIdentifier = item.accessibilityIdentifier
                button.tag = index
                button.addTarget(self, action: #selector(didTapNavigationItem(button:)), for: .touchUpInside)
                view.addSubview(button)
                itemViews.append(button)
            case let .view(view):
                view.accessibilityIdentifier = item.accessibilityIdentifier
                self.view.addSubview(view)
                itemViews.append(view)
            case let .button(button):
                button.tag = index
                button.accessibilityIdentifier = item.accessibilityIdentifier
                button.addTarget(self, action: #selector(didTapNavigationItem(button:)), for: .touchUpInside)
                view.addSubview(button)
                itemViews.append(button)
            }
        }

        separatorViews = (0 ..< items.count - 1)
            .map { _ in
                let view = SeparatorView()
                return view
            }
        separatorViews.forEach(view.addSubview)
    }

    @objc func didTapNavigationItem(button: UIButton) {
        button.isHighlighted = false
        let selectedItem = items[button.tag]

        switch selectedItem.action {
        case .none:
            break
        case let .navigation(viewController: viewController):
            let navigationController = UINavigationController(rootViewController: viewController())
            let barbuttonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .done, target: self, action: #selector(didTapCloseButton(button:)))
            barbuttonItem.accessibilityLabel = L10n.closeButtonLabel
            navigationController.navigationBar.topItem?.setLeftBarButton(barbuttonItem, animated: false)
            present(navigationController, animated: true, completion: nil)
        }
    }

    @objc func didTapCloseButton(button _: UIBarButtonItem) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let maxWidth = view.superview!.bounds.width * 0.9
        let width: CGFloat = min(CGFloat(85 * items.count), maxWidth)
        view.frame.size = CGSize(width: width, height: 56)
        let superView = view.superview!
        view.center = CGPoint(x: superView.center.x, y: superView.frame.maxY - view.frame.size.height)

        let buttonSize = CGSize(width: view.bounds.width / CGFloat(items.count), height: view.bounds.height)
        for (index, view) in (itemViews + separatorViews).enumerated() {
            let newFrame: CGRect
            if index < items.count {
                newFrame = CGRect(origin: CGPoint(x: CGFloat(index) * buttonSize.width, y: 0), size: buttonSize)
            } else {
                newFrame = CGRect(origin: CGPoint(x: CGFloat(index - items.count + 1) * buttonSize.width, y: 0), size: CGSize(width: 1, height: buttonSize.height))
            }
            view.frame = newFrame
        }
        visualEffectView.frame = view.bounds

        (parent as? MapViewController)?.bottomContentOffset = view.frame.height
    }
}
