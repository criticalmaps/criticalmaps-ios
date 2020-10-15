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

    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init(frame: .zero)

        addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
        updateImage()

        if #available(iOS 13.0, *) {
            showsLargeContentViewer = true
            scalesLargeContentImage = true
        }
    }

    @available(*, unavailable)
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
            image = Asset.location.image
        case .follow:
            image = Asset.locationActive.image
        case .followWithHeading:
            image = Asset.locationHeading.image
        }

        setImage(image, for: .normal)
    }

    // MARK: Accessibility

    override var accessibilityLabel: String? {
        get {
            L10n.Map.Headingbutton.accessibilitylabel
        }
        set {}
    }

    override var accessibilityValue: String? {
        get {
            switch currentMode {
            case .none:
                return L10n.Map.Headingbutton.Accessibilityvalue.off
            case .follow:
                return L10n.Map.Headingbutton.Accessibilityvalue.on
            case .followWithHeading:
                return L10n.Map.Headingbutton.Accessibilityvalue.heading
            }
        }
        set {}
    }

    override var largeContentTitle: String? {
        get {
            "\(accessibilityLabel!): \(accessibilityValue!)"
        }
        set {}
    }
}
