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
            let qrCodeImage = filter.outputImage else {
            return
        }
        let ciContext = CIContext(cgContext: context, options: nil)
        let scaleX = rect.size.width / qrCodeImage.extent.size.width
        let scaleY = rect.size.height / qrCodeImage.extent.size.height
        ciContext.draw(qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY)),
                       in: rect, from: rect)
    }
}
