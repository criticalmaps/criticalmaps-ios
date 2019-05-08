//
//  UIWindow+Appearance.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 15.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let CMAppearanceWillRefreshWindow = Notification.Name(rawValue: "CMAppearanceWillRefreshWindowNotification")
    static let CMAppearanceDidRefreshWindow = Notification.Name(rawValue: "CMAppearanceDidRefreshWindowNotification")
}

extension UIWindow {
    // This is needed to see the immediate effect of selecting a theme.
    @nonobjc private func _refreshAppearance() {
        let constraints = self.constraints
        removeConstraints(constraints)
        for subview in subviews {
            subview.removeFromSuperview()
            addSubview(subview)
        }
        addConstraints(constraints)
    }

    /// Refreshes appearance for the window
    ///
    /// - Parameter animated: if the refresh should be animated
    func refreshAppearance(animated: Bool) {
        NotificationCenter.default.post(name: .CMAppearanceWillRefreshWindow, object: self)
        UIView.animate(withDuration: animated ? 0.25 : 0, animations: {
            self._refreshAppearance()
        }, completion: { _ in
            NotificationCenter.default.post(name: .CMAppearanceDidRefreshWindow, object: self)
        })
    }
}
