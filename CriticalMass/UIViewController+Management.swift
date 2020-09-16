//
//  UIViewController+Management.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 24.06.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            Logger.log(.debug, log: .viewManagement, "Expected to have parent", parameter: String(describing: self))
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIViewController {
    func layout(_ viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        var topAnchor: NSLayoutConstraint {
            viewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        }
        NSLayoutConstraint.activate([
            topAnchor,
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
