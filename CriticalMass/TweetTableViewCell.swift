//
//  TweetTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import UIKit

class TweetTableViewCell: UITableViewCell, MessagesTableViewCell {
    @IBOutlet var dateLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.cornerRadius = imageView!.bounds.width / 2
        imageView?.layer.masksToBounds = true
        imageView?.frame.origin.y = textLabel!.frame.origin.y

        dateLabel.sizeToFit()
        dateLabel.center = CGPoint(x: bounds.size.width - 16 - dateLabel.bounds.size.width / 2, y: textLabel!.center.y)
    }

    func setup(for tweet: Tweet) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        dateLabel.text = formatter.string(from: tweet.created_at)
        textLabel?.text = "@\(tweet.user.screen_name)"
        detailTextLabel?.text = tweet.text
        imageView?.sd_setImage(with: URL(string: tweet.user.profile_image_url_https), placeholderImage: UIImage(named: "Avatar"))
    }
}
