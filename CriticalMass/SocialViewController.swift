//
//  SocialViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import UIKit

class SocialViewController: UIViewController, UIToolbarDelegate {
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var contentView: UIView!

    private var chatViewController: UIViewController
    private var twitterController: UIViewController
    init(chatViewController: UIViewController, twitterViewController: UIViewController) {
        self.chatViewController = chatViewController
        twitterController = twitterViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum Tab: String, CaseIterable {
        case chat
        case twitter

        var title: String {
            return NSLocalizedString(rawValue + ".title", comment: "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar.delegate = self

        configureSegmentedControl()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        present(tab: Tab.allCases[0])
    }

    private func configureNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            // hide border
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }

    private func configureSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: Tab.allCases.map { $0.title })
        segmentedControl.sizeToFit()
        segmentedControl.bounds.size.width = view.bounds.width
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(socialSelectionDidChange(control:)), for: .valueChanged)
        segmentedControl.backgroundColor = .clear
        toolBar.setItems([UIBarButtonItem(customView: segmentedControl)], animated: false)
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
        let newViewController: UIViewController

        switch tab {
        case .chat:
            newViewController = chatViewController()
            newViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleBottomMargin]
        case .twitter:
            newViewController = twitterController()
        }
        addChild(newViewController)
        newViewController.view.frame = contentView.bounds
        contentView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
    }

    // Mark: UIToolBarDelegate

    func position(for _: UIBarPositioning) -> UIBarPosition {
        // This delegate method is needed to define the border position
        return .topAttached
    }
}
