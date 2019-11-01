//
//  RulesDetailViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import UIKit

class RulesDetailViewController: UIViewController {
    private var rule: Rule
    private let spacing: CGFloat = 12

    private lazy var scrollView: UIScrollView = {
        UIScrollView()
    }()

    private lazy var ruleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [ruleImageView, descriptionLabel])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 2 * spacing
        return view
    }()

    private lazy var ruleImageView: UIImageView = {
        let imageView = UIImageView(image: rule.artwork)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = rule.text
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var imageViewHeightConstraint = { () -> NSLayoutConstraint in
        let aspectRatio: CGFloat
        if let artwork = rule.artwork {
            aspectRatio = artwork.size.height / artwork.size.width
        } else {
            aspectRatio = 0.6
        }

        return NSLayoutConstraint(
            item: ruleImageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: ruleImageView,
            attribute: .width,
            multiplier: aspectRatio,
            constant: 0)
    }()

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
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for scroll view
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor)
            ])
        }

        ruleImageView.translatesAutoresizingMaskIntoConstraints = false
        ruleStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(ruleStack)

        // Constraints for stack view and image view
        NSLayoutConstraint.activate([
            imageViewHeightConstraint,
            ruleStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            ruleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ruleStack.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: spacing),
            ruleStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: spacing),
            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: ruleStack.bottomAnchor, constant: spacing),
            ruleStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: spacing)
        ])
    }
}
