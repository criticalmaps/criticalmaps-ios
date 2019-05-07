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
        let publicKey: Data
        if let data = try? RSAKey(fromKeychain: RSAKey.keychainTag).publicKeyDataRepresentation() {
            publicKey = data
        } else if let data = try? RSAKey(randomKey: RSAKey.keychainTag).publicKeyDataRepresentation() {
            publicKey = data
        } else {
            fatalError()
        }

        do {
            view.string = try FollowURLObject(queryObject: Friend(name: "TODO", key: publicKey)).asURL()
        } catch {
            // TODO: present error
        }

        view.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        self.view.addSubview(view)
    }
}
