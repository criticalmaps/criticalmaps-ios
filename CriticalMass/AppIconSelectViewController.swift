//
// Created for CriticalMaps in 2020

import UIKit

final class AppIconSelectViewController: UITableViewController {
    private let dataSource = AppIconDataSource()
    private let appIconHelper = AppIconHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    private func setupController() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: AppIconTableViewCell.self)
        tableView.tableFooterView = UIView()

        tableView.dataSource = dataSource
        title = L10n.Settings.appIcon
    }

    // MARK: UITableViewDelegate

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat { 60 }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.rows[indexPath.row].isSelected = true
        appIconHelper.setAppIcon(name: dataSource.rows[indexPath.row].icon.rawValue)
        let rowsWithIndices = zip(dataSource.rows, dataSource.rows.indices)
        for row in rowsWithIndices {
            if row.1 != indexPath.row {
                dataSource.rows[row.1].isSelected = false
            }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

final class AppIconDataSource: NSObject, UITableViewDataSource {
    struct AppIconTableRow: Equatable {
        let icon: AppIcon
        var isSelected: Bool = false
    }

    var rows: [AppIconTableRow] = []

    override init() {
        super.init()
        initializeDataSource()
    }

    private func initializeDataSource() {
        if let iconName = UIApplication.shared.alternateIconName {
            _ = AppIcon.allCases.map {
                let isSelected = $0.rawValue == iconName
                let row = AppIconTableRow(icon: $0, isSelected: isSelected)
                rows.append(row)
            }
        } else {
            for item in zip(AppIcon.allCases, AppIcon.allCases.indices) {
                var row = AppIconTableRow(icon: item.0)
                if case .light = item.0 {
                    row.isSelected = true
                }
                rows.append(row)
            }
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: AppIconTableViewCell.self)
        let row = rows[indexPath.row]
        cell.accessoryType = row.isSelected ? .checkmark : .none
        cell.iconPreview.image = row.icon.image
        cell.title.text = row.icon.name
        return cell
    }
}

final class AppIconHelper {
    func setAppIcon(name: String) {
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(name) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
