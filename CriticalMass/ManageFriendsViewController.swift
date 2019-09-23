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

        configureNavigationBar()
        tableView.register(cellType: FriendTableViewCell.self)
    }

    private func configureNavigationBar() {
        title = "Friends"
        let addFriendBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendButtonTapped))
        navigationItem.rightBarButtonItem = addFriendBarButtonItem
    }

    @objc func addFriendButtonTapped() {
        let viewController = FollowFriendsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(ofType: FriendTableViewCell.self, for: indexPath)
    }
}
