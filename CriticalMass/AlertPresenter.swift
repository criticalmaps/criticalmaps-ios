//
// Created for CriticalMaps in 2020

import UIKit

final class AlertPresenter {
    private var viewController: UIViewController? {
        UIApplication.shared.keyWindow?.rootViewController
    }

    static let shared = AlertPresenter()

    private init() {}

    func presentAlert(
        title: String?,
        message: String? = nil,
        preferredStyle: UIAlertController.Style,
        actionData: [UIAlertAction],
        isCancelable: Bool = false
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actionData.forEach(alert.addAction(_:))
        if isCancelable {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
        }
        onMain {
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
