//
//  BikeAnnotationView.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/18/19.
//

import MapKit

extension Friend {
    static let testFriend = Friend.init(name: "Klaus",
                                        token: "VGVzdEtleQ%3D%3D".data(using: .utf8)!)
}

class BikeAnnoationView: MKAnnotationView {
    static let reuseIdentifier = "BikeAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        image = UIImage(named: "Bike")
        canShowCallout = false
    }
}

class FriendAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "FriendAnnotationView"

    var friend: Friend = Friend.testFriend

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
        image = #imageLiteral(resourceName: "Twitter_Active")
    }
}
