//
//  FollowFriendsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import UIKit

class FollowFriendsViewController: UIViewController {
    private var urlString: String?
    private var name: String

    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow100

        configureNavigationBar()

        do {
            let publicKeyData = try RSAKey(tag: RSAKey.keychainTag).publicKeyDataRepresentation()
            urlString = try FollowURLObject(queryObject: Friend(name: name, key: publicKeyData)).asURL()
        } catch {
            // TODO: present error
            fatalError()
        }

        configureQRCodeView()
    }

    private func configureNavigationBar() {
        title = "Friends"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareLinkButtonTapped))
    }

    private func configureQRCodeView() {
        let view = QRCodeView()
        view.backgroundColor = .clear
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
