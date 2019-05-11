//
//  FollowFriendsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import UIKit

class FollowFriendsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureQRCodeView()
    }

    private func configureQRCodeView() {
        let view = QRCodeView()

        do {
            let publicKeyData = try RSAKey(tag: RSAKey.keychainTag).publicKeyDataRepresentation()
            view.text = try FollowURLObject(queryObject: Friend(name: "TODO", key: publicKeyData)).asURL()
        } catch {
            // TODO: present error
            fatalError()
        }

        view.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        self.view.addSubview(view)
    }
}
