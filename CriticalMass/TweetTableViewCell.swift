//
//  TweetTableViewCell.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell, MessagesTableViewCell {
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    func setup(for _: Tweet) {}
}
