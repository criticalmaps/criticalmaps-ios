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
        case followWithHeading

        init(_ mkUserTrackingMode: MKUserTrackingMode) {
            switch mkUserTrackingMode {
            case .follow:
                self = .follow
            case .followWithHeading:
                self = .followWithHeading
            case .none:
                self = .none
            @unknown default:
                assertionFailure()
                self = .none
            }
        }
    }

    weak var mapView: MKMapView?
    var currentMode: Mode = .none {
        didSet {
            if currentMode != oldValue {
                updateImage()
            }
        }
    }

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
            transitionModeChangeWitScale(newMode: .followWithHeading) { _ in
                self.mapView?.setUserTrackingMode(.followWithHeading, animated: true)
            }
        case .followWithHeading:
            transitionModeChangeWitScale(newMode: .none) { _ in
                self.mapView?.setUserTrackingMode(.none, animated: true)
            }
        }
    }

    private func transitionModeChangeWitScale(newMode: Mode, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.currentMode = newMode
                self.transform = .identity
            }, completion: completion)
        }
    }

    private func updateImage() {
        let image: UIImage?
        switch currentMode {
        case .none:
            image = UIImage(named: "Location")
        case .follow:
            image = UIImage(named: "LocationActive")
        case .followWithHeading:
            image = UIImage(named: "LocationHeading")
        }

        setImage(image, for: .normal)
    }
}
