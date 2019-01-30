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
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.textColor = .twitterDate
        textLabel?.textColor = .twitterUsername
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.layer.cornerRadius = imageView!.bounds.width / 2
        imageView?.layer.masksToBounds = true
        imageView?.frame.origin.y = textLabel!.frame.origin.y

        dateLabel.sizeToFit()
        dateLabel.center = CGPoint(x: bounds.size.width - 16 - dateLabel.bounds.size.width / 2, y: textLabel!.center.y)
        textLabel?.frame.size = CGSize(width: dateLabel.frame.minX - textLabel!.frame.origin.x - 12, height: textLabel!.frame.size.height)
    }

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

    private func attributedBodyString(for tweet: Tweet) -> NSAttributedString {
        let text = tweet.text
        let words = text.components(separatedBy: " ").filter { $0.hasPrefix("#") || $0.hasPrefix("@") }
        let bodyString = NSMutableAttributedString(string: text)
        for word in words {
            bodyString.addAttribute(.foregroundColor, value: UIColor.twitterLink, range: NSRange(text.range(of: word)!, in: text))
        }
        return bodyString
    }

    func setup(for tweet: Tweet) {
        dateLabel.text = dateString(for: tweet)
        textLabel?.attributedText = attributedUserNameString(for: tweet)
        detailTextLabel?.attributedText = attributedBodyString(for: tweet)
        imageView?.sd_setImage(with: URL(string: tweet.user.profile_image_url_https), placeholderImage: UIImage(named: "Avatar"))
    }
}
