//
//  RulesDetailViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import UIKit

class RuleDetailTextView: UITextView {
    @objc
    dynamic var ruleDetailTextColor: UIColor? {
        willSet {
            textColor = newValue
        }
    }
}

class RulesDetailViewController: UIViewController {
    private var rule: Rule
    private var textView = RuleDetailTextView(frame: .zero)
    
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
        textView.frame = view.bounds
        
        textView.isEditable = false
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .gray300
        textView.adjustsFontForContentSizeCategory = true
        view.addSubview(textView)
        
        updateContentInset()
        updateTextViewContent()
    }
    
    private func updateContentInset() {
        let additionalLeadingInsets: CGFloat
        let additionalTrailingInsets: CGFloat
        if #available(iOS 11.0, *) {
            additionalLeadingInsets = view.safeAreaInsets.left
            additionalTrailingInsets = view.safeAreaInsets.right
        } else {
            additionalLeadingInsets = 0
            additionalTrailingInsets = 0
        }
        
        textView.contentInset = UIEdgeInsets(top: 12, left: 12 + additionalLeadingInsets, bottom: 12, right: 12 + additionalTrailingInsets)
    }
    
    private func updateTextViewContent() {
        let attributedString = NSMutableAttributedString()
        
        if let artWork = rule.artwork {
            let artworkAttachment = NSTextAttachment()
            artworkAttachment.image = artWork
            let ratio = artWork.size.height / artWork.size.width
            let artworkPadding = textView.contentInset.left +
                textView.contentInset.right +
                textView.textContainer.lineFragmentPadding
            let artworkWidth = view.bounds.width - artworkPadding
            artworkAttachment.bounds.size = CGSize(width: artworkWidth, height: artworkWidth * ratio)
            
            attributedString.append(NSAttributedString(attachment: artworkAttachment))
        }
        attributedString.append(NSAttributedString(string: rule.text))
        
        textView.attributedText = attributedString
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateContentInset()
        updateTextViewContent()
    }
}
