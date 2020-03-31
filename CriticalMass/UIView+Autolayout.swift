//
//  UIView+Autolayout.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 30.09.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }

    func addLayoutsCenter(in view: UIView, size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        addConstraints([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width),
        ])
    }

    func addLayoutsSameSizeAndOrigin(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            heightAnchor.constraint(equalTo: view.heightAnchor),
            widthAnchor.constraint(equalTo: view.widthAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
}
