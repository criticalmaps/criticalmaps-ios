//
// Created for CriticalMaps in 2020

import MapKit

@available(iOS 11.0, *)
class BikeClusterAnnotationView: MKAnnotationView {
    static let clusteringIdentifier = "BikeCluster"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {
            let totalBikes = cluster.memberAnnotations.count
            image = drawBikeCluster(totalBikes: totalBikes)
            displayPriority = .defaultLow
        }
    }

    private func drawBikeCluster(totalBikes: Int, wholeColor: UIColor = .cmYellow) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            wholeColor.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 30, height: 30)).fill()

            // draw count text
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
            ]
            let text = "\(totalBikes)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 15 - size.width / 2, y: 15 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
