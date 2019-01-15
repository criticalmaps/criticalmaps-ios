//
//  Colors.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import UIKit

extension UIColor {
    private class func safeInit(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
        } else {
            return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
        }
    }

    static var rulesDetailText: UIColor {
        return safeInit(red: 69, green: 71, blue: 77, alpha: 1)
    }

    static var rulesOverViewCell: UIColor {
        return safeInit(red: 38, green: 38, blue: 38, alpha: 1)
    }
}
