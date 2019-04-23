//
//  TweetTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import UIKit

class TweetTableViewCell: UITableViewCell, MessagesTableViewCell {
    @objc
    dynamic var handleLabelTextColor: UIColor? {
        didSet {
            handleLabel.textColor = handleLabelTextColor
        }
    }

    @objc
    dynamic var dateLabelTextColor: UIColor? {
        didSet {
            dateLabel.textColor = dateLabelTextColor
        }
    }

    @objc
    dynamic var linkTintColor: UIColor? {
        didSet {
            tweetTextView.tintColor = linkTintColor
        }
    }

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var tweetTextView: UITextView! {
        didSet {
            tweetTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        }
    }

    @IBOutlet private var handleLabel: UILabel!
    @IBOutlet private var userImageView: UIImageView!

    private func attributedUserNameString(for tweet: Tweet) -> NSAttributedString {
        let boldFont = UIFont(descriptor: textLabel!.font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        let usernameString = NSMutableAttributedString(string: tweet.user.name, attributes: [
            .font: boldFont,
        ])
        usernameString.append(NSAttributedString(string: " @\(tweet.user.screen_name)", attributes: [:]))
        return usernameString
    }

    func setup(for tweet: Tweet) {
        dateLabel.text = FormatDisplay.dateString(for: tweet)
        tweetTextView.text = tweet.text
        handleLabel.attributedText = attributedUserNameString(for: tweet)
        userImageView.sd_setImage(with: URL(string: tweet.user.profile_image_url_https), placeholderImage: UIImage(named: "Avatar"))
    }
}

extension TweetTableViewCell: UITextViewDelegate {
    // Opens a link in Safari
    func textView(_: UITextView, shouldInteractWith _: URL, in _: NSRange) -> Bool {
        return true
    }
}
