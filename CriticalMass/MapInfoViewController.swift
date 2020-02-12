//
//  CriticalMaps

import CoreLocation
import UIKit

class MapInfoViewController: UIViewController, IBConstructable {
    @IBOutlet private var infoViewContainer: UIView!

    typealias CompletionHandler = () -> Void

    private var infoView = MapInfoView.fromNib()
    private var visibleBottomConstraint: NSLayoutConstraint!
    private var infoViewContainerTopConstraint: NSLayoutConstraint {
        if #available(iOS 11.0, *) {
            return infoViewContainer.topAnchor.constraint(equalTo: view.safeTopAnchor)
        }
        return infoViewContainer.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 20)
    }

    public var closeButtonHandler: MapInfoView.TapHandler? {
        get { infoView.closeButtonHandler }
        set { infoView.closeButtonHandler = newValue }
    }

    public var tapHandler: MapInfoView.TapHandler? {
        get { infoView.tapHandler }
        set { infoView.tapHandler = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    fileprivate func setup() {
        infoViewContainer.addSubview(infoView)
        infoView.addLayoutsSameSizeAndOrigin(in: infoViewContainer)

        visibleBottomConstraint = infoViewContainerTopConstraint
        visibleBottomConstraint.priority = .required
        view.addConstraints([visibleBottomConstraint])

        visibleBottomConstraint.isActive = false
        infoViewContainer.isHidden = true

        infoView.closeButtonHandler = {
            self.dismissMapInfo()
        }
    }

    public func presentMapInfo(title: String, style: MapInfoView.Configuration.Style) {
        func animateIn() {
            infoView.configure(with: MapInfoView.Configuration(title: title, style: style))
            infoViewContainer.isHidden = false

            let animator = UIViewPropertyAnimator(
                duration: 0.2,
                timingParameters: UICubicTimingParameters.linearOutSlow
            )
            animator.addAnimations {
                self.visibleBottomConstraint.isActive = true
                self.view.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                UIAccessibility.post(notification: .layoutChanged, argument: self.view)
            }
            animator.startAnimation()
        }

        if infoView.isHidden {
            animateIn()
        } else {
            dismissMapInfo(animated: false) {
                animateIn()
            }
        }
    }

    public func dismissMapInfo(animated: Bool = true, _ completion: CompletionHandler? = nil) {
        defer { completion?() }
        if !animated {
            visibleBottomConstraint.isActive = false
            infoViewContainer.isHidden = true
            UIAccessibility.post(notification: .layoutChanged, argument: view)
        } else {
            let animator = UIViewPropertyAnimator(
                duration: 0.2,
                timingParameters: UICubicTimingParameters.fastOutLiner
            )
            animator.addAnimations {
                self.visibleBottomConstraint.isActive = false
                self.view.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                self.infoViewContainer.isHidden = true
                UIAccessibility.post(notification: .layoutChanged, argument: self.view)
            }
            animator.startAnimation()
        }
    }
}

// https://material.io/design/motion/speed.html#easing
private extension UICubicTimingParameters {
    static var linearOutSlow: UITimingCurveProvider {
        UICubicTimingParameters(controlPoint1: .init(x: 0.0, y: 0.0), controlPoint2: .init(x: 0.2, y: 1.0))
    }

    static var fastOutLiner: UITimingCurveProvider {
        UICubicTimingParameters(controlPoint1: .init(x: 0.4, y: 0.0), controlPoint2: .init(x: 1.0, y: 1.0))
    }
}

private extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
}
