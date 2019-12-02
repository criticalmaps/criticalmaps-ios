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
        let control = UISegmentedControl(items: SocialSegments.allCases.map { $0.title })
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

    enum SocialSegments: String, CaseIterable {
        case chat
        case twitter

        var title: String {
            NSLocalizedString(rawValue + ".title", comment: "")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
        configureNavigationBar()
        present(segment: .chat)
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
        present(segment: SocialSegments.allCases[control.selectedSegmentIndex])
    }

    private func present(segment: SocialSegments) {
        switch segment {
        case .chat:
            twitterController.remove()
            add(chatViewController)
            layout(chatViewController)
        case .twitter:
            chatViewController.remove()
            add(twitterController)
            layout(twitterController)
        }
    }
}
