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
        let idStore = IDStore()
        let view = QRCodeView()
        let publicKey: Data
        if let data = try? RSAKey(fromKeychain: RSAKey.keychainTag).publicKeyDataRepresentation() {
            publicKey = data
        } else if let data = try? RSAKey(randomKey: RSAKey.keychainTag).publicKeyDataRepresentation() {
            publicKey = data
        } else {
            fatalError()
        }
        guard let urlEncodedURLString = publicKey.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        view.string = "criticalmaps:follow?key=\(urlEncodedURLString)"
        view.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        self.view.addSubview(view)
    }
}
