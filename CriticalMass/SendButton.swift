//
//  SendButton.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 13.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class SendButton: UIButton {
    @objc
    dynamic var sendMessageButtonColor: UIColor? {
        willSet {
            tintColor = newValue
        }
    }

    @objc
    dynamic var sendMessageButtonBGColor: UIColor? {
        willSet {
            setBackgroundColor(color: .gray,
                               forState: .disabled)
            setBackgroundColor(color: newValue ?? .black,
                               forState: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = bounds.height / 2
    }
}

private extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        clipsToBounds = true
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        let img = renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        setBackgroundImage(img, for: forState)
    }
}
