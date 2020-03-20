//
//  BikeAnnotationView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit

class BikeAnnoationView: MKAnnotationView {
    private enum Constants {
        static let shapeRect = CGRect(x: 0, y: 0, width: 7, height: 7)
    }

    private lazy var ovalShapeLayer: CAShapeLayer = {
        $0.path = UIBezierPath(ovalIn: frame).cgPath
        $0.fillColor = UIColor.cmYellow.cgColor
        return $0
    }(CAShapeLayer())

    @objc
    dynamic var shapeBackgroundColor: UIColor? {
        willSet {
            guard let fillColor = newValue else { return }
            ovalShapeLayer.fillColor = fillColor.cgColor
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
        backgroundColor = .clear

        frame = Constants.shapeRect
        layer.addSublayer(ovalShapeLayer)

        if #available(iOS 11.0, *) {
            clusteringIdentifier = BikeClusterAnnotationView.clusteringIdentifier
        }
    }
}
