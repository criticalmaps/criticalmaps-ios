//
//  RoundedCornerImageView.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 12.03.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

@IBDesignable
class RoundableImageView: UIImageView {
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.applyCornerRadius()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            self.applyCornerRadius()
        }
    }
    
    @IBInspectable var borderWidth : Double = 0.0 {
        didSet {
            self.applyCornerRadius()
        }
    }
    
    @IBInspectable var circular : Bool = false {
        didSet {
            self.applyCornerRadius()
        }
    }
    
    private func applyCornerRadius() {
        if self.circular {
            self.layer.cornerRadius = self.bounds.size.height / 2
        } else {
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.masksToBounds = true
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = CGFloat(self.borderWidth)
    }
    
    private func addInnerShadow() {
        let innerShadow = CALayer()
        innerShadow.frame = bounds
        let path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: -1, dy: -1))
        let cutout = UIBezierPath(ovalIn: self.bounds).reversing()
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.shadowColor = UIColor.twitterProfileInnerBorder.cgColor
        innerShadow.shadowOffset = .zero
        innerShadow.shadowOpacity = 1.0
        innerShadow.shadowRadius = 0.0
        // Add
        layer.addSublayer(innerShadow)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyCornerRadius()
        self.addInnerShadow()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.applyCornerRadius()
        self.addInnerShadow()
    }
}
