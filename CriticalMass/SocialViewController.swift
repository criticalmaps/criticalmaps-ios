//
//  SocialViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import UIKit

@objc(PLSocialViewController)
class SocialViewController: UIViewController {
    enum Tab: String, CaseIterable {
        case chat
        case twitter

        var title: String {
            return NSLocalizedString(rawValue + ".title", comment: "")
        }

        var viewController: UIViewController {
            switch self {
            case .chat:
                return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: PLChatViewController.self))
            case .twitter:
                return PLTwitterViewController()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSegmentedControl()
        present(tab: Tab.allCases[0])
    }

    private func configureNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    private func configureSegmentedControl() {
        // TODO: move segmented control to the bottom of the navbar
        let segment: UISegmentedControl = UISegmentedControl(items: Tab.allCases.map { $0.title })
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(socialSelectionDidChange(control:)), for: .valueChanged)
        navigationItem.titleView = segment
    }

    @objc private func socialSelectionDidChange(control: UISegmentedControl) {
        present(tab: Tab.allCases[control.selectedSegmentIndex])
    }

    private func present(tab: Tab) {
        children.forEach { viewController in
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
        let newViewController = tab.viewController
        addChild(newViewController)
        view.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
    }
}
