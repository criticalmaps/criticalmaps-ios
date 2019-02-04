//
//  NavigationOverlayViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/3/19.
//

import UIKit

struct NavigationOverlayItem {
    enum Action {
        case navigation(viewController: () -> UIViewController)
        case action(() -> Void)
    }

    let action: Action
    let icon: UIImage
}

class NavigationOverlayViewController: UIViewController {
    private var items: [NavigationOverlayItem]

    init(navigationItems: [NavigationOverlayItem]) {
        items = navigationItems
        super.init(nibName: nil, bundle: nil)
        configure(items: navigationItems)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIVisualEffectView()
        view.accessibilityViewIsModal = true
        view.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true

        view.layer.shadowOpacity = 0.8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 4
        self.view = view
    }

    var visualEffectView: UIVisualEffectView {
        return view as! UIVisualEffectView
    }

    private func configure(items: [NavigationOverlayItem]) {
        for (index, item) in items.enumerated() {
            let button = UIButton(frame: .zero)
            button.setImage(item.icon, for: .normal)
            button.tintColor = .navigationOverlayForeground
            button.tag = index
            button.addTarget(self, action: #selector(didTapNavigationItem(button:)), for: .touchUpInside)
            visualEffectView.contentView.addSubview(button)
        }

        (0 ..< items.count - 1)
            .map { _ in
                let view = UIView()
                view.backgroundColor = .navigationOverlaySeparator
                return view
            }.forEach(visualEffectView.contentView.addSubview)
    }

    @objc func didTapNavigationItem(button: UIButton) {
        let selectedItem = items[button.tag]

        switch selectedItem.action {
        case let .action(closure):
            closure()
        case let .navigation(viewController: viewController):
            let navigationController = UINavigationController(rootViewController: viewController())
            let barbuttonItem = UIBarButtonItem(image: UIImage(named: "Close"), style: .done, target: self, action: #selector(didTapCloseButton(button:)))
            barbuttonItem.tintColor = .black
            navigationController.navigationBar.topItem?.setLeftBarButton(barbuttonItem, animated: false)

            present(navigationController, animated: true, completion: nil)
        }
    }

    @objc func didTapCloseButton(button _: UIBarButtonItem) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        view.frame.size = CGSize(width: 340, height: 50)
        let superView = view.superview!
        view.center = CGPoint(x: superView.center.x, y: superView.frame.maxY - view.frame.size.height)

        let buttonSize = CGSize(width: view.bounds.width / CGFloat(items.count), height: view.bounds.height)
        for (index, view) in visualEffectView.contentView.subviews.enumerated() {
            let newFrame: CGRect
            if index < items.count {
                newFrame = CGRect(origin: CGPoint(x: CGFloat(index) * buttonSize.width, y: 0), size: buttonSize)
            } else {
                newFrame = CGRect(origin: CGPoint(x: CGFloat(index - items.count + 1) * buttonSize.width, y: 0), size: CGSize(width: 1, height: buttonSize.height))
            }
            view.frame = newFrame
        }
    }
}
