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
        navigationController?.navigationBar.tintColor = .black
        configureTextView()
    }

    private func configureTextView() {
        let textView = UITextView(frame: view.bounds)
        textView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        let attributedString = NSMutableAttributedString()

        if let artWork = rule.artwork {
            let artworkAttachment = NSTextAttachment()
            artworkAttachment.image = artWork
            let ratio = artWork.size.height / artWork.size.width
            let artworkPadding = textView.contentInset.left + textView.contentInset.right + textView.textContainer.lineFragmentPadding
            let artworkWidth = view.bounds.width - artworkPadding
            artworkAttachment.bounds.size = CGSize(width: artworkWidth, height: artworkWidth * ratio)
            attributedString.append(NSAttributedString(attachment: artworkAttachment))
        }

        attributedString.append(NSAttributedString(string: rule.text))

        textView.attributedText = attributedString
        textView.isEditable = false
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .rulesDetailText
        textView.adjustsFontForContentSizeCategory = true
        view.addSubview(textView)
    }
}
