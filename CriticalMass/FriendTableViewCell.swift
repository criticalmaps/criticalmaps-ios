//
//  FriendTableViewCell.swift
//
//
//  Created by Leonard Thomas on 22.09.19.
//

import UIKit

class FriendTableViewCell: UITableViewCell, IBConstructable {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var onlineIndicatorView: UIView!
    
    @objc
    dynamic var nameColor: UIColor? {
        willSet {
            nameLabel.textColor = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        onlineIndicatorView.layer.cornerRadius = 8
        onlineIndicatorView.backgroundColor = .onlineGreen
    }

    public func configure(name: String, isOnline: Bool) {
        nameLabel.text = name
        onlineIndicatorView.isHidden = !isOnline
    }
}
