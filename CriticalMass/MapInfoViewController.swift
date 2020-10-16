//
//  CriticalMaps

import CoreLocation
import UIKit

class MapInfoViewController: UIViewController, IBConstructable {
    @IBOutlet private var infoViewContainer: UIView! {
        didSet {
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeUpGestureRecognizer))
            swipeUpGesture.direction = .up
            infoViewContainer.addGestureRecognizer(swipeUpGesture)
        }
    }

    private let animationDuration: TimeInterval = 0.2

    typealias CompletionHandler = () -> Void

    private var infoView = MapInfoView.fromNib()
    private var visibleBottomConstraint: NSLayoutConstraint!
    private var infoViewContainerTopConstraint: NSLayoutConstraint {
        infoViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
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

    private func setup() {
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

    /// Called when the mapInfoViewContainer is swiped up
    @objc private func onSwipeUpGestureRecognizer() {
        dismissMapInfo()
    }

    public func configureAndPresentMapInfoView(
        title: String,
        style: MapInfoView.Configuration.Style,
        _ completion: CompletionHandler? = nil
    ) {
        func animateIn() {
            infoView.configure(with: MapInfoView.Configuration(title: title, style: style))
            infoViewContainer.isHidden = false

            let animator = UIViewPropertyAnimator(
                duration: animationDuration,
                timingParameters: UICubicTimingParameters.linearOutSlow
            )
            animator.addAnimations {
                self.visibleBottomConstraint.isActive = true
                self.view.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                completion?()
                UIAccessibility.post(notification: .layoutChanged, argument: self.view)
            }
            animator.startAnimation()
        }

        if !visibleBottomConstraint.isActive {
            animateIn()
        } else {
            dismissMapInfo(animated: false) {
                animateIn()
            }
        }
    }

    public func dismissMapInfo(animated: Bool = true, _ completion: CompletionHandler? = nil) {
        let finishBlock: () -> Void = {
            UIAccessibility.post(notification: .layoutChanged, argument: self.view)
            completion?()
        }
        if !animated {
            visibleBottomConstraint.isActive = false
            infoViewContainer.isHidden = true
            finishBlock()
        } else {
            let animator = UIViewPropertyAnimator(
                duration: animationDuration,
                timingParameters: UICubicTimingParameters.fastOutLiner
            )
            animator.addAnimations {
                self.visibleBottomConstraint.isActive = false
                self.view.layoutIfNeeded()
            }
            animator.addCompletion { _ in
                self.infoViewContainer.isHidden = true
                finishBlock()
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
