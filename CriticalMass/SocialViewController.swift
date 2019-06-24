//
//  SocialViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import UIKit

class SocialViewController: UIViewController, UIToolbarDelegate {
    private var chatViewController: UIViewController
    private var twitterController: UIViewController

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: Tab.allCases.map { $0.title })
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(socialSelectionDidChange(control:)),
                          for: .valueChanged)
        control.backgroundColor = .clear
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

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
        configureSegmentedControl()
        configureNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        present(tab: .chat)
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
        navigationItem.titleView = segmentedControl
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: self.navigationItem.titleView!.centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalTo: navigationItem.titleView!.heightAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 180.0),
        ])
    }

    @objc private func socialSelectionDidChange(control: UISegmentedControl) {
        present(tab: Tab.allCases[control.selectedSegmentIndex])
    }

    private func present(tab: Tab) {
        switch tab {
        case .chat:
            remove(child: twitterController)
            add(child: chatViewController)
        case .twitter:
            remove(child: chatViewController)
            add(child: twitterController)
        }
    }
}
