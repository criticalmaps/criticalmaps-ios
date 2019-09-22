//
//  ManageFriendsViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 22.09.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

class ManageFriendsViewController: UIViewController, IBConstructable, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: FriendTableViewCell.self)
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(ofType: FriendTableViewCell.self, for: indexPath)
    }
}
