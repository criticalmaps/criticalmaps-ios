//
//  ErrorStateViewController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 04.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

typealias ReloadHandler = () -> Void

class ErrorStateViewController: UIViewController, IBConstructable {
    @IBOutlet private weak var errorTitle: UILabel!
    @IBOutlet private weak var errorMessage: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    var reloadHandler: ReloadHandler?
    var errorStateModel: ErrorStateModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        errorTitle.text = errorStateModel.errorTitle
        errorMessage.text = errorStateModel.errorMessage
    }

    @IBAction func reload(_ sender: Any) {
        reloadHandler?()
    }
}

extension ErrorStateViewController {
    static func createErrorStateController(with viewModel: ErrorStateModel) -> ErrorStateViewController {
        let controller = ErrorStateViewController.fromNib()
        controller.errorStateModel = viewModel
        return controller
    }

    static let fallback = createErrorStateController(with: .fallback)
}
