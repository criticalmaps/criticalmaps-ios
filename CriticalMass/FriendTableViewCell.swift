//
//  FriendTableViewCell.swift
//
//
//  Created by Leonard Thomas on 22.09.19.
//

import UIKit

class FriendTableViewCell: UITableViewCell, IBConstructable {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var onlineIndicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        onlineIndicatorView.layer.cornerRadius = 8
    }
}
