//
//  FollowFriendsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import UIKit

class FollowFriendsViewController: UIViewController {
    private var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        do {
            let publicKeyData = try RSAKey(tag: RSAKey.keychainTag).publicKeyDataRepresentation()
            urlString = try FollowURLObject(queryObject: Friend(name: "TODO", key: publicKeyData)).asURL()
        } catch {
            // TODO: present error
            fatalError()
        }

        configureQRCodeView()
        configureShareLinkButton()
    }

    private func configureShareLinkButton() {
        let button = UIButton()
        button.setTitle("Share Link", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(shareLinkButtonTapped), for: .touchUpInside)
        button.sizeToFit()
        button.center = view.center.applying(CGAffineTransform(translationX: 0, y: -200))
        view.addSubview(button)
    }

    private func configureQRCodeView() {
        let view = QRCodeView()
        view.text = urlString
        view.frame.size = CGSize(width: 200, height: 200)
        view.center = self.view.center
        self.view.addSubview(view)
    }

    @objc func shareLinkButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [urlString!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
}
