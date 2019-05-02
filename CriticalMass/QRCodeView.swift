//
//  QRCodeView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/2/19.
//

import UIKit

class QRCodeView: UIView {
    var string: String? {
        didSet {
            if let string = string {
                data = string.data(using: .ascii)
            } else {
                data = nil
            }
        }
    }

    private var data: Data? {
        didSet {
            filter?.setValue(data, forKey: "inputMessage")
            setNeedsDisplay()
        }
    }

    private var filter: CIFilter? = CIFilter(name: "CIQRCodeGenerator")
    private var context = CIContext(options: nil)

    override func draw(_ rect: CGRect) {
        guard let outputImage = filter?.outputImage,
            let cgContext = UIGraphicsGetCurrentContext() else {
            return
        }
        let transform = CGAffineTransform(scaleX: rect.width / outputImage.extent.width, y: rect.height / outputImage.extent.height)
        let scaledImage = outputImage.transformed(by: transform)
        CIContext(cgContext: cgContext, options: nil).draw(scaledImage, in: scaledImage.extent, from: scaledImage.extent)
    }
}
