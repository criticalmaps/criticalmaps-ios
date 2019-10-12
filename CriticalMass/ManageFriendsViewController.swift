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
    private var idProvider: IDProvider!

    enum Section: Int, CaseIterable {
        case friends
        case settings

        var title: String? {
            switch self {
            case .friends:
                return nil
            case .settings:
                return "Settings"
            }
        }
    }

    init(dataStore: DataStore, idProvider: IDProvider) {
        self.dataStore = dataStore
        self.idProvider = idProvider
        super.init(nibName: ManageFriendsViewController.nibName, bundle: ManageFriendsViewController.bundle)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        tableView.register(cellType: FriendTableViewCell.self)
        tableView.register(cellType: FriendSettingsTableViewCell.self)
        tableView.register(viewType: SettingsTableSectionHeader.self)
    }

    private func configureNavigationBar() {
        title = "Friends"
        let addFriendBarButtonItem = UIBarButtonItem(title: "Add Friend", style: .plain, target: self, action: #selector(addFriendButtonTapped))
        navigationItem.rightBarButtonItem = addFriendBarButtonItem
    }

    @objc func addFriendButtonTapped() {
        let viewController = FollowFriendsViewController(name: dataStore.userName, token: idProvider.token)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func update(name: String) {
        dataStore.userName = name
    }

    func numberOfSections(in _: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .friends:
            return dataStore.friends.count
        case .settings:
            return 1
        }
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = Section(rawValue: section)?.title else {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(ofType: SettingsTableSectionHeader.self)
        header.titleLabel.text = title
        return header
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section(rawValue: section)! {
        case .friends:
            return 0.0
        case .settings:
            return 42.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .friends:
            let cell = tableView.dequeueReusableCell(ofType: FriendTableViewCell.self, for: indexPath)
            let friend = dataStore.friends[indexPath.row]
            // isOnline isn't supported yet
            cell.configure(name: friend.name, isOnline: false)
            return cell
        case .settings:
            let cell = tableView.dequeueReusableCell(ofType: FriendSettingsTableViewCell.self, for: indexPath)
            cell.configure(name: dataStore.userName, nameChanged: update)
            return cell
        }
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataStore.remove(friend: dataStore.friends[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
