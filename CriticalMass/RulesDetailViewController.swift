//
//  RulesDetailViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import UIKit

class RulesDetailViewController: UIViewController {
    private var rule: Rule

    init(rule: Rule) {
        self.rule = rule
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = rule.title
        configureTextView()
    }

    private func configureTextView() {
        let textView = UITextView(frame: view.bounds)
        textView.text = rule.text
        textView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.isEditable = false
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .rulesDetailText
        if #available(iOS 10.0, *) {
            textView.adjustsFontForContentSizeCategory = true
        }
        view.addSubview(textView)
    }
}
