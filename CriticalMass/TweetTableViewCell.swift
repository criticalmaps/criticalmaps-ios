//
//  TweetTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import UIKit

extension DateComponents {
    fileprivate var dateComponentFromBiggestComponent: DateComponents {
        if let month = month,
            month != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: month, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else if let day = day,
            day != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else if let hour = hour,
            hour != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: hour, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else if let minute = minute,
            minute != 0 {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: minute, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        } else {
            return DateComponents(calendar: calendar, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: second, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        }
    }
}

class TweetTableViewCell: UITableViewCell, MessagesTableViewCell {
    
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var tweetTextView: UITextView! {
        didSet {
            tweetTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0,
right: 0.0)
        }
    }
    @IBOutlet private var handleLabel: UILabel!
    @IBOutlet private var userImageView: UIImageView!
    
    private func dateString(for tweet: Tweet) -> String? {
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: tweet.created_at, to: Date()).dateComponentFromBiggestComponent
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .month, .second]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 1
        return formatter.string(from: components)
    }

    private func attributedUserNameString(for tweet: Tweet) -> NSAttributedString {
        let boldFont = UIFont(descriptor: textLabel!.font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        let usernameString = NSMutableAttributedString(string: tweet.user.name, attributes: [.foregroundColor: UIColor.twitterName,
                                                                                             .font: boldFont])
        usernameString.append(NSAttributedString(string: " @\(tweet.user.screen_name)", attributes: [.foregroundColor: UIColor.twitterUsername]))
        return usernameString
    }

    func setup(for tweet: Tweet) {
        dateLabel.text = dateString(for: tweet)
        tweetTextView.text = tweet.text
        handleLabel.attributedText = attributedUserNameString(for: tweet)
        userImageView.sd_setImage(with: URL(string: tweet.user.profile_image_url_https), placeholderImage: UIImage(named: "Avatar"))
    }
}

extension TweetTableViewCell: UITextViewDelegate {
    
    // Opens a link in Safari
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
}
