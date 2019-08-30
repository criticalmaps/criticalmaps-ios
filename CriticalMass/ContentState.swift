//
//  ContentState.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 30.08.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

enum ContentState<T> {
    case loading(LoadingViewController)
    case results(T)
    case error
}

protocol ContentStatePresentable {
    var contentStateViewController: UIViewController? { get set }
    func addAndLayoutStateView(_ viewController: UIViewController, in view: UIView)
}

extension ContentStatePresentable where Self: UIViewController {
    func addAndLayoutStateView(_ viewController: UIViewController, in view: UIView) {
        add(viewController)
        let contentStateView = viewController.view!
        contentStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStateView.topAnchor.constraint(equalTo: view.topAnchor),
            contentStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
}
