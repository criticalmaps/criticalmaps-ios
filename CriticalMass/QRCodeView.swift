//
//  QRCodeView.swift
//  CriticalMapsTests
//
//  Created by Leonard Thomas on 5/11/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class QRCodeView: UIView {
    var text: String? {
        didSet {
            filter.setValue(text?.data(using: .utf8), forKey: "inputMessage")
        }
    }

    private let filter = CIFilter(name: "CIQRCodeGenerator")!

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              let qrCodeImage = filter.outputImage?.applyingFilter("CIFalseColor", parameters: ["inputColor0": CIColor.black,
                                                                                                "inputColor1": CIColor.clear])
        else {
            return
        }

        let ciContext = CIContext(cgContext: context, options: nil)
        let scaleX = rect.size.width / qrCodeImage.extent.size.width
        let scaleY = rect.size.height / qrCodeImage.extent.size.height
        ciContext.draw(qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY)),
                       in: rect, from: rect)
    }
}

class QRCodeBackgroundView: UIView {
    override func draw(_ rect: CGRect) {
        let borderLength: CGFloat = 32
        let lineWidth: CGFloat = 4

        let path = UIBezierPath(roundedRect: rect.inset(by: UIEdgeInsets(top: lineWidth, left: lineWidth, bottom: lineWidth, right: lineWidth)), cornerRadius: 4)

        let clipPath = UIBezierPath()

        clipPath.append(UIBezierPath(rect: CGRect(origin: .zero, size: CGSize(width: borderLength, height: borderLength))))

        clipPath.append(UIBezierPath(rect: CGRect(origin: CGPoint(x: bounds.width - borderLength, y: 0), size: CGSize(width: borderLength, height: borderLength))))

        clipPath.append(UIBezierPath(rect: CGRect(origin: CGPoint(x: bounds.width - borderLength, y: bounds.height - borderLength), size: CGSize(width: borderLength, height: borderLength))))

        clipPath.append(UIBezierPath(rect: CGRect(origin: CGPoint(x: 0, y: bounds.height - borderLength), size: CGSize(width: borderLength, height: borderLength))))

        clipPath.addClip()

        path.lineWidth = lineWidth
        path.lineJoinStyle = .round

        UIGraphicsGetCurrentContext()?.setStrokeColor(UIColor.yellow80.cgColor)

        path.stroke()
    }
}
