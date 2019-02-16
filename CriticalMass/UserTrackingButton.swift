//
//  UserTrackingButton.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 2/16/19.
//

import MapKit

class UserTrackingButton: CustomButton {
    enum Mode {
        case none
        case follow
    }

    weak var mapView: MKMapView?
    var currentMode: Mode = .none

    override var tintColor: UIColor! {
        didSet {
            highlightedTintColor = tintColor.withAlphaComponent(0.4)
        }
    }

    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(frame: .zero)

        addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        updateImage()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTappedButton() {
        switch currentMode {
        case .none:
            currentMode = .follow
            mapView?.setUserTrackingMode(.follow, animated: true)
        case .follow:
            currentMode = .none
            mapView?.setUserTrackingMode(.none, animated: true)
        }
        updateImage()
    }

    private func updateImage() {
        let image: UIImage?
        switch currentMode {
        case .none:
            image = UIImage(named: "Location")
        case .follow:
            image = UIImage(named: "LocationActive")
        }

        setImage(image, for: .normal)
    }
}
