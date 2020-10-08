//
// Created for CriticalMaps in 2020

import UIKit

final class ThemeSelectionViewController: UITableViewController {
    fileprivate let themeController: ThemeController

    init(themeController: ThemeController) {
        self.themeController = themeController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    private func setupController() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: ThemeSelectionTableViewCell.self)
        tableView.tableFooterView = UIView()

        tableView.dataSource = self
        title = L10n.themeAppearanceLocalizedString
    }

    // MARK: UITableViewDelegate

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat { 60 }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        themeController.changeTheme(to: Theme.allCases[indexPath.row])
        themeController.applyTheme()
        for index in 0 ... Theme.allCases.count {
            let isSelected = index == indexPath.row
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) else {
                return
            }
            cell.configure(isSelected: isSelected)
        }
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        Theme.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: ThemeSelectionTableViewCell.self)
        let themeOption = Theme.allCases[indexPath.row]
        cell.configure(isSelected: themeOption == themeController.currentTheme)
        cell.title.text = themeOption.displayName
        return cell
    }
}
