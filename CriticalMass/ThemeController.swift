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
    private(set) var currentTheme: Theme!
    private let store: ThemeStorable

    init(store: ThemeStorable = ThemeSelectionStore()) {
        self.store = store
        currentTheme = loadTheme()
    }

    func changeTheme(to theme: Theme) {
        currentTheme = theme
        store.save(currentTheme)
    }

    private func loadTheme() -> Theme {
        if #available(iOS 13.0, *) {
            let theme = Theme(userInterfaceStyle: UITraitCollection.current.userInterfaceStyle)
            return theme
        } else {
            return store.load() ?? .light
        }
    }

    /// Applies the current selected theme to the apps UI components
    func applyTheme() {
        let theme = currentTheme.style
        styleGlobalComponents(with: theme)
        styleSocialComponets(with: theme)
        styleRulesComponents(with: theme)
        styleSettingsComponents(with: theme)
        styleFriendsComponents(with: theme)
        styleNavigationOverlayComponents(with: theme)
        styleMapComponents(with: theme)
        NoContentMessageLabel.appearance().messageTextColor = theme.titleTextColor
        NoContentTitleLabel.appearance().messageTextColor = theme.titleTextColor
        NotificationCenter.default.post(name: .themeDidChange, object: nil) // trigger map tileRenderer update
        UIApplication.shared.refreshAppearance(animated: false)
    }

    private func styleRulesComponents(with theme: ThemeDefining) {
        RuleTableViewCell.appearance().ruleTextColor = theme.titleTextColor
        RuleDescriptionLabel.appearance().descriptionTextColor = theme.titleTextColor

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = theme.backgroundColor
            appearance.largeTitleTextAttributes = [.foregroundColor: theme.titleTextColor]
            appearance.titleTextAttributes = [.foregroundColor: theme.titleTextColor]
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
        }
    }

    private func styleSettingsComponents(with theme: ThemeDefining) {
        // UISwitch
        UISwitch.appearance().onTintColor = theme.switchTintColor
        // Custom Views
        SettingsFooterView.appearance().versionTextColor = theme.titleTextColor
        SettingsFooterView.appearance().buildTextColor = theme.titleTextColor
        SettingsGithubTableViewCellTableViewCell.appearance().arrowTintColor = .settingsOpenSourceForeground
        UILabel.appearance(whenContainedInInstancesOf: [SettingsInfoTableViewCell.self]).textColor = theme.titleTextColor
        SettingsSwitchTableViewCell.appearance().titleColor = theme.titleTextColor
        SettingsSwitchTableViewCell.appearance().subtitleColor = theme.thirdTitleTextColor
    }

    private func styleNavigationOverlayComponents(with theme: ThemeDefining) {
        CustomButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).highlightedTintColor = theme.titleTextColor.withAlphaComponent(0.6)
        CustomButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).defaultTintColor = theme.titleTextColor
        ChatNavigationButton.appearance().unreadMessagesBackgroundColor = .red
        ChatNavigationButton.appearance().unreadMessagesTextColor = .white
        OverlayView.appearance().overlayBackgroundColor = theme.navigationOverlayBackgroundColor
    }

    private func styleSocialComponets(with theme: ThemeDefining) {
        // UISegmentedControl
        if #available(iOS 13.0, *) {
            UISegmentedControl.appearance().selectedSegmentTintColor = theme.titleTextColor
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: theme.backgroundColor], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: theme.titleTextColor], for: .normal)
        } else {
            UISegmentedControl.appearance().backgroundColor = theme.backgroundColor
            UISegmentedControl.appearance().tintColor = theme.titleTextColor
        }
        TweetTableViewCell.appearance().dateLabelTextColor = theme.secondaryTitleTextColor
        TweetTableViewCell.appearance().handleLabelTextColor = theme.thirdTitleTextColor
        TweetTableViewCell.appearance().userameTextColor = theme.titleTextColor
        TweetTableViewCell.appearance().linkTintColor = theme.tintColor
        UITextView.appearance(whenContainedInInstancesOf: [TweetTableViewCell.self]).textColor = theme.titleTextColor
        UIButton.appearance(whenContainedInInstancesOf: [ChatInputViewController.self]).tintColor = theme.backgroundColor
        ChatMessageTableViewCell.appearance().timeLabelTextColor = theme.titleTextColor
        ChatMessageTableViewCell.appearance().chatTextColor = theme.secondaryTitleTextColor
        // UIToolBar
        UIToolbar.appearance().barTintColor = theme.toolBarBackgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [TweetTableViewCell.self]).textColor = theme.titleTextColor
        UILabel.appearance(whenContainedInInstancesOf: [ChatNavigationButton.self]).textColor = .white
        UIView.appearance(whenContainedInInstancesOf: [LoadingViewController.self]).backgroundColor = theme.backgroundColor
        UIView.appearance(whenContainedInInstancesOf: [ErrorStateViewController.self]).backgroundColor = theme.backgroundColor
        UIButton.appearance(whenContainedInInstancesOf: [ErrorStateViewController.self]).backgroundColor = .cmYellow
        SendButton.appearance().sendMessageButtonBGColor = theme.titleTextColor
        ChatBackGroundView.appearance().backgroundColor = theme.chatInputBackgroundColor
    }

    private func styleGlobalComponents(with theme: ThemeDefining) {
        SeparatorView.appearance().backgroundColor = theme.separatorColor
        UIApplication.shared.delegate?.window??.tintColor = theme.tintColor
        // NavigationBar
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().tintColor = theme.titleTextColor
        UINavigationBar.appearance().isTranslucent = theme.navigationBarIsTranslucent
        // UIBarButtonItem
        UIBarButtonItem.appearance().tintColor = theme.titleTextColor
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
        let cellSelectedBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = theme.cellSelectedBackgroundViewColor
            return view
        }()
        UITableViewCell.appearance().selectedBackgroundView = cellSelectedBackgroundView // can only be set via a subclassed UIView
        // UIScrollView
        UIScrollView.appearance().backgroundColor = theme.backgroundColor
        // UITableViewHeaderFooterView
        UITableViewHeaderFooterView.appearance().backgroundColor = theme.backgroundColor
        UIRefreshControl.appearance().tintColor = theme.titleTextColor
        UITextView.appearance().textColor = theme.titleTextColor
        // UILabel
        UITableView.appearance().tintColor = theme.titleTextColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = theme.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = theme.titleTextColor
    }

    private func styleFriendsComponents(with theme: ThemeDefining) {
        FriendSettingsTableViewCell.appearance().titleLabelColor = theme.titleTextColor
        FriendSettingsTableViewCell.appearance().placeholderColor = theme.settingsPlaceholderColor
        FriendSettingsTableViewCell.appearance().textFieldColor = theme.titleTextColor
        FriendTableViewCell.appearance().nameColor = theme.titleTextColor
        ManageFriendsViewController.backgroundAndTableViewColor = theme.backgroundColor
    }

    private func styleMapComponents(with theme: ThemeDefining) {
        BlurryFullscreenOverlayView.appearance().gradientBeginColor = theme.gradientBeginColor
        BlurryFullscreenOverlayView.appearance().gradientEndColor = theme.gradientEndColor

        MapInfoView.appearance().mapInfoForegroundColor = theme.mapInfoForegroundColor
        MapInfoView.appearance().mapInfoBackgroundColor = theme.mapInfoBackgroundColor
    }
}

extension ThemeController: Switchable {
    var isEnabled: Bool {
        get { currentTheme == .dark }
        set {
            changeTheme(to: newValue ? .dark : .light)
            // This is a workaround to wait for the switch animation to finish before updating the UI
            onMain {
                self.applyTheme()
            }
        }
    }
}
