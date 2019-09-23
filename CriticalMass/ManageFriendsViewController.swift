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
    private var dataStore: DataStore!

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        super.init(nibName: ManageFriendsViewController.nibName, bundle: ManageFriendsViewController.bundle)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        return dataStore.friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: FriendTableViewCell.self, for: indexPath)
        let friend = dataStore.friends[indexPath.row]
        // isOnline isn't supported yet
        cell.configure(name: friend.name, isOnline: false)
        return cell
    }
}
