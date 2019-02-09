//
//  AnnotationRenderer.swift
//  Critiical Maps Watch Extension
//
//  Created by Leonard Thomas on 2/9/19.
//

import WatchKit

struct AnnotationRenderer {
    let numberOfElements: Int
    let size: CGSize

    var image: UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 2)

        let context = UIGraphicsGetCurrentContext()

        UIColor.blue.withAlphaComponent(0.8).setFill()
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))

        let string = "\(numberOfElements)" as NSString
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let labelSize = string.size(withAttributes: attributes)

        string.draw(at: CGPoint(x: (size.width / 2) - (labelSize.width / 2), y: (size.height / 2) - (labelSize.height / 2)), withAttributes: attributes)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
