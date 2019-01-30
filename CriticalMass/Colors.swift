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

    static var chatInputBackground: UIColor {
        return safeInit(red: 250, green: 250, blue: 250, alpha: 1)
    }

    static var chatInputTextfieldBackground: UIColor {
        return safeInit(red: 218, green: 220, blue: 224, alpha: 1)
    }

    static var chatInputSendButton: UIColor {
        return safeInit(red: 38, green: 38, blue: 38, alpha: 1)
    }

    static var chatInputSeparator: UIColor {
        return safeInit(red: 218, green: 220, blue: 224, alpha: 1)
    }

    static var chatInputPlaceholder: UIColor {
        return safeInit(red: 69, green: 71, blue: 77, alpha: 1)
    }

    static var chatMessageDate: UIColor {
        return safeInit(red: 38, green: 38, blue: 38, alpha: 1)
    }

    static var chatMessageText: UIColor {
        return safeInit(red: 69, green: 71, blue: 77, alpha: 1)
    }

    static var twitterName: UIColor {
        return safeInit(red: 38, green: 38, blue: 38, alpha: 1)
    }

    static var twitterUsername: UIColor {
        return safeInit(red: 144, green: 147, blue: 153, alpha: 1)
    }

    static var twitterText: UIColor {
        return safeInit(red: 69, green: 71, blue: 77, alpha: 1)
    }

    static var twitterDate: UIColor {
        return safeInit(red: 38, green: 38, blue: 38, alpha: 1)
    }

    static var twitterLink: UIColor {
        return safeInit(red: 29, green: 161, blue: 242, alpha: 1)
    }
}
