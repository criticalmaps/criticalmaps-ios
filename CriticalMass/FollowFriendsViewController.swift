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
        view.string = "criticalmaps:follow?id=\(idStore.id)"
        view.frame = CGRect(x: 100, y: 200, width: 200, height: 200)
        self.view.addSubview(view)
    }
}
