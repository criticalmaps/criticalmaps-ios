//
//  CriticalMaps

import CoreLocation
import UIKit

// https://material.io/design/motion/speed.html#easing
extension UICubicTimingParameters {
    static var linearOutSlow: UITimingCurveProvider {
        UICubicTimingParameters(controlPoint1: .init(x: 0.0, y: 0.0), controlPoint2: .init(x: 0.2, y: 1.0))
    }

    static var fastOutLiner: UITimingCurveProvider {
        UICubicTimingParameters(controlPoint1: .init(x: 0.4, y: 0.0), controlPoint2: .init(x: 1.0, y: 1.0))
    }
}

class MapInfoViewController: UIViewController, IBConstructable {
    @IBOutlet private var infoViewContainer: UIView!
    @IBOutlet private var infoViewContainerTopConstraint: NSLayoutConstraint!

    typealias CompletionHandler = () -> Void

    private enum Constants {
        static let infoBarDismissed = CGFloat(-110)
        static let infoBarVisible = CGFloat(0)
        static let infoBarVisibleTimeInterval: TimeInterval = 0.25
        static let infoBarDismissTimeInterval: TimeInterval = 0.2
    }

    private var infoView = MapInfoView.fromNib()

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

        infoViewContainer.addSubview(infoView)
        infoView.addLayoutsSameSizeAndOrigin(in: infoViewContainer)
        infoViewContainerTopConstraint.constant = Constants.infoBarDismissed
        infoView.isHidden = true

        infoView.closeButtonHandler = {
            self.dismissMapInfo()
        }
    }

    public func presentMapInfo(title: String, style: MapInfoView.Configuration.Style) {
        func animateIn() {
            infoView.configure(with: MapInfoView.Configuration(title: title, style: style))
            infoView.isHidden = false

            let animator = UIViewPropertyAnimator(
                duration: Constants.infoBarVisibleTimeInterval,
                timingParameters: UICubicTimingParameters.linearOutSlow
            )
            animator.addAnimations {
                self.infoViewContainerTopConstraint.constant = Constants.infoBarVisible
                self.view.layoutIfNeeded()
            }
            animator.startAnimation()

            UIAccessibility.post(notification: .layoutChanged, argument: view)
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
            infoViewContainerTopConstraint.constant = Constants.infoBarDismissed
            infoView.isHidden = true
        } else {
            let animator = UIViewPropertyAnimator(
                duration: Constants.infoBarVisibleTimeInterval,
                timingParameters: UICubicTimingParameters.fastOutLiner
            )
            animator.addAnimations {
                self.infoViewContainerTopConstraint.constant = Constants.infoBarDismissed
                self.view.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                self.infoView.isHidden = true
            }
            animator.startAnimation()
        }
    }
}
