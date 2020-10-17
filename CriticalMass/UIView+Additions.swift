//
//  UIView+Autolayout.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 30.09.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension UIView {
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

extension UIView {
    /**
     Fade in a view with a duration
     - parameter duration: custom animation duration
     */
    func fadeIn(duration: TimeInterval = 0.3) {
        isHidden = false
        if alpha != 0.0 { alpha = 0.0 }
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: { self.alpha = 1.0 },
            completion: nil
        )
    }

    /**
     Fade out a view with a duration
     - parameter duration: custom animation duration
     */
    func fadeOut(duration: TimeInterval = 0.3) {
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: { self.alpha = 0.0 },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.isHidden = true
            }
        )
    }
}
