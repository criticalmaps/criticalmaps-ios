//
//  ThemeController.swift
//  CriticalMaps
//
//  Created by Malte Bünz on 09.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation
import UIKit

class ThemeController {
    private(set) lazy var currentTheme = loadTheme()
    private let store: ThemeStorable

    init(store: ThemeStorable = ThemeSelectionStore()) {
        self.store = store
    }

    func changeTheme(to theme: Theme) {
        currentTheme = theme
        store.save(currentTheme)
    }

    private func loadTheme() -> Theme {
        guard let theme = store.load() else {
            return .light
        }
        return theme
    }

    func applyTheme() {
        let theme = currentTheme.style
        UIApplication.shared.delegate?.window??.tintColor = theme.tintColor
        UITextField.appearance().keyboardAppearance = theme.keyboardAppearance
        // NavigationBar
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().tintColor = theme.titleTextColor
        UINavigationBar.appearance().isTranslucent = theme.navigationBarIsTranslucent
        // UIBarButtonItem
        UIBarButtonItem.appearance().tintColor = theme.titleTextColor
        // UITableView
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
        let cellSelectedBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = theme.cellSelectedBackgroundViewColor
            return view
        }()
        UITableViewCell.appearance().selectedBackgroundView = cellSelectedBackgroundView
        // UIScrollView
        UIScrollView.appearance().backgroundColor = theme.backgroundColor
        // UITableViewHeaderFooterView
        UITableViewHeaderFooterView.appearance().backgroundColor = theme.backgroundColor
        // UISegmentedControl
        UISegmentedControl.appearance().backgroundColor = theme.backgroundColor
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UIToolbar.self]).tintColor = theme.titleTextColor
        // UISwitch
        UISwitch.appearance().onTintColor = theme.switchTintColor // Settings switches
        // UIToolBar
        UIToolbar.appearance().barTintColor = theme.backgroundColor
        // Custom Views
        SettingsFooterView.appearance().versionTextColor = theme.titleTextColor
        SettingsFooterView.appearance().buildTextColor = theme.titleTextColor
        RuleTableViewCell.appearance().ruleTextColor = theme.titleTextColor
        RuleDetailTextView.appearance().ruleDetailTextColor = theme.titleTextColor
        TweetTableViewCell.appearance().dateLabelTextColor = theme.secondaryTitleTextColor
        TweetTableViewCell.appearance().handleLabelTextColor = theme.titleTextColor
        TweetTableViewCell.appearance().linkTintColor = theme.tintColor
        UITextView.appearance(whenContainedInInstancesOf: [TweetTableViewCell.self]).textColor = theme.secondaryTitleTextColor
        ChatInputView.appearance().backgroundColor = theme.backgroundColor
        ChatInputView.appearance().textViewTextColor = theme.titleTextColor
        ChatInputView.appearance().sendMessageButtonColor = theme.titleTextColor
        TextFieldWithInsets.appearance().textFieldBackgroundColor = theme.chatMessageInputTextViewBackgroundColor
        ChatMessageTableViewCell.appearance().timeLabelTextColor = theme.titleTextColor
        ChatMessageTableViewCell.appearance().chatTextTextColor = theme.titleTextColor
        SeperatorView.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).backgroundColor = theme.navigationOverlaySeperatorColor
        SeperatorView.appearance(whenContainedInInstancesOf: [ChatInputView.self]).backgroundColor = theme.navigationOverlaySeperatorColor

        UIRefreshControl.appearance().tintColor = theme.refreshControlColor

        UITextView.appearance().textColor = theme.titleTextColor
        // UILabel
        UITableView.appearance().tintColor = theme.titleTextColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = theme.titleTextColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = theme.titleTextColor
        UILabel.appearance(whenContainedInInstancesOf: [TweetTableViewCell.self]).textColor = theme.titleTextColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = theme.backgroundColor // Settings: SectionHeader
        NotificationCenter.default.post(name: NSNotification.themeDidChange, object: nil) // trigger map tileRenderer update

        // NavigationOverlayItems
        UIView.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).backgroundColor = theme.backgroundColor
        UIButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).tintColor = theme.titleTextColor
        UIButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).setTitleColor(theme.titleTextColor.withAlphaComponent(0.5), for: .highlighted)

        UIApplication.shared.refreshAppearance(animated: false)
    }
}
