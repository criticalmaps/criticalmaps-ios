//
//  BikeAnnotationView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit

class BikeAnnoationView: MKAnnotationView {
    private enum Constants {
        static let defaultSize = CGRect(x: 0, y: 0, width: 7, height: 7)
        static let large = CGRect(x: 0, y: 0, width: 10, height: 10)
        static let extraLarge = CGRect(x: 0, y: 0, width: 14, height: 14)
        static let extraExtraLarge = CGRect(x: 0, y: 0, width: 20, height: 20)
    }

    @objc
    dynamic var shapeBackgroundColor: UIColor? {
        willSet {
            guard let fillColor = newValue else { return }
            backgroundColor = fillColor
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        canShowCallout = false
        backgroundColor = UIColor.cmYellow

        frame = defineFrame()
        layer.cornerRadius = frame.height / 2
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    private func defineFrame() -> CGRect {
        switch traitCollection.preferredContentSizeCategory {
        case .extraSmall, .small, .medium, .large:
            return Constants.defaultSize
        case .extraLarge:
            return Constants.large
        case .extraExtraLarge:
            return Constants.extraLarge
        case .extraExtraExtraLarge, .accessibilityMedium, .accessibilityLarge, .accessibilityExtraLarge, .accessibilityExtraExtraLarge, .accessibilityExtraExtraExtraLarge:
            return Constants.extraExtraLarge
        default:
            return Constants.defaultSize
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        frame = defineFrame()
        layer.cornerRadius = frame.height / 2
        setNeedsDisplay()
    }
}

class FriendAnnotationView: MKAnnotationView {
    var friendView: FriendView?

    var friend: Friend? {
        didSet {
            friendView?.name = friend?.name ?? ""
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        canShowCallout = false

        friendView = FriendView(frame: .init(x: 0, y: 0, width: 109, height: 23))
        friendView!.backgroundColor = .clear
        friendView!.name = friend?.name ?? ""
        addSubview(friendView!)
    }
}

class FriendView: UIView {
    var name: String!

    override func draw(_: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let blueFillColor = UIColor.lightGray.withAlphaComponent(0.4)
        let color2 = UIColor(red: 0.14, green: 0.61, blue: 0.95, alpha: 1.00)
        let whiteColor = UIColor.white

        context?.saveGState()
        context?.setAlpha(0.5)

        let rectanglePath = UIBezierPath(roundedRect: .init(x: 0, y: 0, width: 109, height: 23), cornerRadius: 11.5)
        blueFillColor.setFill()
        rectanglePath.fill()

        context?.restoreGState()

        let oval2Path = UIBezierPath(ovalIn: .init(x: 0, y: 0, width: 23, height: 23))
        whiteColor.setFill()
        oval2Path.fill()

        let ovalPath = UIBezierPath(ovalIn: .init(x: 3.5, y: 3.5, width: 16, height: 16))
        color2.setFill()
        ovalPath.fill()

        let textRect = CGRect(x: 26, y: 2, width: 80, height: 19)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .heavy),
            .foregroundColor: UIColor.black,
            .paragraphStyle: textStyle,
        ]

        let textHeight: CGFloat = name.boundingRect(with: .init(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil).height
        context?.saveGState()
        context?.clip(to: textRect)
        name.draw(in: CGRect(x: textRect.minX,
                             y: textRect.minY + (textRect.height - textHeight) / 2,
                             width: textRect.width,
                             height: textHeight))
        context?.restoreGState()
    }
}
