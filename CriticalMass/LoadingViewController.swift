//
//  LoadingViewController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 20.07.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, IBConstructable {
    @IBOutlet var logoView: CMLogoActivityView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logoView.startAnimating()
    }
}

extension LoadingViewController {
    static let `default` = LoadingViewController.fromNib()
}
