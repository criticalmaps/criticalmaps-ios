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
                return L10n.settingsFriendsSettings
            }
        }
    }

    static var backgroundAndTableViewColor: UIColor?

    init(dataStore: DataStore, idProvider: IDProvider) {
        self.dataStore = dataStore
        self.idProvider = idProvider
        super.init(nibName: ManageFriendsViewController.nibName, bundle: ManageFriendsViewController.bundle)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureNotifications()

        tableView.register(cellType: FriendTableViewCell.self)
        tableView.register(cellType: FriendSettingsTableViewCell.self)
        tableView.register(viewType: SettingsTableSectionHeader.self)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let backgroundColor = ManageFriendsViewController.backgroundAndTableViewColor {
            tableView.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
    }

    private func configureNavigationBar() {
        title = L10n.settingsFriends
        let addFriendBarButtonItem = UIBarButtonItem(title: L10n.settingsFriendsShowID, style: .plain, target: self, action: #selector(addFriendButtonTapped))
        navigationItem.rightBarButtonItem = addFriendBarButtonItem
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNewData), name: .positionOthersChanged, object: nil)
    }

    @objc private func addFriendButtonTapped() {
        let viewController = FollowFriendsViewController(name: dataStore.userName, token: idProvider.token)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc private func handleTap() {
        view.endEditing(true)
    }

    private func update(name: String) {
        dataStore.userName = name
    }

    @objc private func onNewData() {
        tableView.reloadSections(IndexSet(integer: Section.friends.rawValue), with: .automatic)
    }

    func numberOfSections(in _: UITableView) -> Int {
        Section.allCases.count
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
            cell.configure(name: friend.name, isOnline: friend.isOnline)
            return cell
        case .settings:
            let cell = tableView.dequeueReusableCell(ofType: FriendSettingsTableViewCell.self, for: indexPath)
            cell.configure(name: dataStore.userName, nameChanged: update)
            return cell
        }
    }

    func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section)! {
        case .friends:
            return true
        case .settings:
            return false
        }
    }

    func tableView(_: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataStore.remove(friend: dataStore.friends[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .friends:
            let friend = dataStore.friends[indexPath.row]
            if friend.isOnline {
                NotificationCenter.default.post(name: .focusLocation, object: friend.location)
                dismiss(animated: true, completion: nil)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case .settings:
            break
        }
    }
}
