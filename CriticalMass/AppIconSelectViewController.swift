//
// Created for CriticalMaps in 2020

import UIKit

enum AppIcon: String, CaseIterable {
    case original, dark, rainbow, yellow, neon

    var name: String {
        String(rawValue.prefix(1).uppercased() + rawValue.dropFirst())
    }

    private var fileName: String {
        switch self {
        case .dark:
            return "CMDarkIcon@3x"
        case .rainbow:
            return "CMRainbowIcon@3x"
        case .yellow:
            return "CMYellowIcon@3x"
        case .neon:
            return "CMNeonIcon@3x"
        case .original:
            return "AppIcon"
        }
    }

    var image: UIImage? {
        var documentsUrl: URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "png") else { return nil }
        do {
            let imageData = try Data(contentsOf: url)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}

struct AppIconTableRow: Equatable {
    let icon: AppIcon
    var isSelected: Bool
}

final class AppIconSelectViewController: UITableViewController {
    private var rows: [AppIconTableRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: AppIconTableViewCell.self)

        title = L10n.appIconTitle

        tableView.tableFooterView = UIView()

        setup()
    }

    private func setup() {
        if let iconName = UIApplication.shared.alternateIconName {
            _ = AppIcon.allCases.map {
                let isSelected = $0.rawValue == iconName
                let row = AppIconTableRow(icon: $0, isSelected: isSelected)
                rows.append(row)
            }
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat { 60 }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { rows.count }

    override func numberOfSections(in _: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: AppIconTableViewCell.self)
        let row = rows[indexPath.row]
        cell.accessoryType = row.isSelected ? .checkmark : .none
        cell.iconPreview.image = row.icon.image
        cell.title.text = row.icon.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rows[indexPath.row].isSelected = true
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(rows[indexPath.row].icon.rawValue) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Done!")
                }
            }
        }
        let rowsWithIndices = zip(rows, rows.indices)
        for row in rowsWithIndices {
            if row.1 != indexPath.row {
                rows[row.1].isSelected = false
            }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
