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
        switch self {
        case .cork: return L10n.Rules.Title.cork
        case .contraflow: return L10n.Rules.Title.contraflow
        case .gently: return L10n.Rules.Title.gently
        case .brake: return L10n.Rules.Title.brake
        case .green: return L10n.Rules.Title.green
        case .stayLoose: return L10n.Rules.Title.stayLoose
        case .haveFun: return L10n.Rules.Title.haveFun
        }
    }

    var text: String {
        switch self {
        case .cork: return L10n.Rules.Text.cork
        case .contraflow: return L10n.Rules.Text.contraflow
        case .gently: return L10n.Rules.Text.gently
        case .brake: return L10n.Rules.Text.brake
        case .green: return L10n.Rules.Text.green
        case .stayLoose: return L10n.Rules.Text.stayLoose
        case .haveFun: return L10n.Rules.Text.haveFun
        }
    }

    var artwork: UIImage? {
        UIImage(named: rawValue.prefix(1).uppercased() + rawValue.dropFirst())
    }
}

class RulesViewController: UITableViewController {
    private let rules = Rule.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        configureNavigationBar()
        registerCell()

        // remove empty cells
        tableView.tableFooterView = UIView()
    }

    private func configureNavigationBar() {
        title = L10n.Rules.title
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
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
