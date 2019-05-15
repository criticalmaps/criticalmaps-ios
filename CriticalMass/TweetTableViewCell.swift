//
//  TweetTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import UIKit

class TweetTableViewCell: UITableViewCell, MessageConfigurable, IBConstructable {
    @objc
    dynamic var userameTextColor: UIColor? {
        willSet {
            userNameLabel.textColor = newValue
        }
    }

    @objc
    dynamic var handleLabelTextColor: UIColor? {
        willSet {
            handleLabel.textColor = newValue
        }
    }

    @objc
    dynamic var dateLabelTextColor: UIColor? {
        willSet {
            dateLabel.textColor = newValue
        }
    }

    @objc
    dynamic var linkTintColor: UIColor? {
        willSet {
            tweetTextView.tintColor = newValue
        }
    }

    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var tweetTextView: UITextView! {
        didSet {
            tweetTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        }
    }

    @IBOutlet private var handleLabel: UILabel!
    @IBOutlet private var userImageView: UIImageView!

    func setup(for tweet: Tweet) {
        dateLabel.text = FormatDisplay.dateString(for: tweet)
        tweetTextView.text = tweet.text
        handleLabel.text = "@\(tweet.user.screen_name)"
        userNameLabel.text = tweet.user.name
        userImageView.sd_setImage(with: URL(string: tweet.user.profile_image_url_https), placeholderImage: UIImage(named: "Avatar"))
    }
}

extension TweetTableViewCell: UITextViewDelegate {
    // Opens a link in Safari
    func textView(_: UITextView, shouldInteractWith _: URL, in _: NSRange) -> Bool {
        return true
    }
}
