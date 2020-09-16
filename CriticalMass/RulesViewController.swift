//
//  RulesViewController.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import UIKit

enum Rule: String, CaseIterable {
    case cork
    case contraflow
    case gently
    case brake
    case green
    case stayLoose
    case haveFun

    var title: String {
        NSLocalizedString("rules.title.\(rawValue)", comment: "")
    }

    var text: String {
        NSLocalizedString("rules.text.\(rawValue)", comment: "")
    }

    var artwork: UIImage? {
        UIImage(named: rawValue.prefix(1).uppercased() + rawValue.dropFirst())
    }
}

class RulesViewController: UITableViewController {
    private let rules = Rule.allCases
    private let themeController: ThemeController

    init(themeController: ThemeController) {
        self.themeController = themeController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension

        navigationController?.view.backgroundColor = themeController.currentTheme.style.backgroundColor

        updateThemeIfNeeded()
        configureNotifications()
        configureNavigationBar()
        registerCell()

        // remove empty cells
        tableView.tableFooterView = UIView()
    }

    private func configureNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateThemeIfNeeded),
            name: .themeDidChange,
            object: nil
        )
    }

    @objc private func updateThemeIfNeeded() {
        if #available(iOS 13.0, *) {
            if themeController.currentTheme == .dark {
                overrideUserInterfaceStyle = .dark
            } else {
                overrideUserInterfaceStyle = .light
            }
        }
    }

    private func configureNavigationBar() {
        title = L10n.rulesTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func registerCell() {
        tableView.register(cellType: RuleTableViewCell.self)
    }

    // MARK: UITableViewDataSource

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        60
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        rules.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: RuleTableViewCell.self)
        cell.label?.text = rules[indexPath.row].title
        return cell
    }

    // MARK: UITableViewDataDelegate

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rule = rules[indexPath.row]
        let detailViewController = RulesDetailViewController(rule: rule)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
