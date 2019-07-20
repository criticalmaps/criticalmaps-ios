//
//  LoadingViewController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 20.07.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    private lazy var activityView: CMLogoActivityView = {
        let view = CMLogoActivityView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityView.startAnimating()
    }

    private func layoutViews() {
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.widthAnchor.constraint(equalToConstant: 80),
            activityView.heightAnchor.constraint(equalToConstant: 80),
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
