//
//  SocialViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/15/19.
//

import UIKit

protocol ChatMessageActivityDelegate: AnyObject {
    func isSendingChatMessage(_ sending: Bool)
}

class SocialViewController: UIViewController, UIToolbarDelegate {
    private enum Constants {
        static let loadingIndicatorSize = CGSize(width: 30,
                                                 height: 30)
        static let scaleFactor = loadingIndicatorSize.width / 100
        static let logoActivityFrame = CGRect(x: 0,
                                              y: 0,
                                              width: loadingIndicatorSize.width,
                                              height: loadingIndicatorSize.height)
    }

    private var chatViewController: ChatViewController
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

    private lazy var loadingBarButton: UIBarButtonItem = {
        let loadingIndicator = CMLogoActivityView(frame: Constants.logoActivityFrame)
        loadingIndicator.backgroundColor = .clear
        loadingIndicator.transform = .init(scaleX: Constants.scaleFactor,
                                           y: Constants.scaleFactor)
        loadingIndicator.startAnimating()
        let barButtonItem = UIBarButtonItem(customView: loadingIndicator)
        barButtonItem.accessibilityLabel = String.loadingButtonLabel
        return barButtonItem
    }()

    init(chatViewController: ChatViewController, twitterViewController: UIViewController) {
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
        chatViewController.chatMessageActivityDelegate = self
        configureNavigationBar()
        configureSegmentedControl()
        present(segment: .chat)
    }

    private func configureNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationItem.largeTitleDisplayMode = .never
            // hide border
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        loadingBarButton.isHidden = true
        navigationItem.setRightBarButton(loadingBarButton, animated: false)
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

extension SocialViewController: ChatMessageActivityDelegate {
    func isSendingChatMessage(_ sending: Bool) {
        loadingBarButton.isHidden = !sending
    }
}

private extension UIBarButtonItem {
    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }
        set(hide) {
            customView?.isHidden = hide
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = nil // This sets the tinColor back to the default. If you have a custom color, use that instead
            }
        }
    }
}
