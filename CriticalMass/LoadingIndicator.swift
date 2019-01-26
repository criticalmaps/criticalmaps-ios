//
//  LoadingIndicator.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/26/19.
//

import UIKit

class LoadingIndicator: UIView {
    private let loadingIndiactorBackgroundView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        return view
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.startAnimating()
        return indicator
    }()

    private init() {
        super.init(frame: .zero)
        addSubview(loadingIndiactorBackgroundView)
        loadingIndiactorBackgroundView.addSubview(loadingIndicator)
        loadingIndicator.center = loadingIndiactorBackgroundView.center
        loadingIndiactorBackgroundView.center = center
        loadingIndiactorBackgroundView.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func present(in view: UIView) -> LoadingIndicator {
        let indicator = LoadingIndicator()
        indicator.frame = view.bounds
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(indicator)
        return indicator
    }

    public func dismiss() {
        removeFromSuperview()
    }
}
