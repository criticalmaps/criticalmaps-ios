//
//  ThemeControllerTests.swift
//  CriticalMapsTests
//
//  Created by Malte Bünz on 11.04.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class ThemeControllerTests: XCTestCase {
    var sut: ThemeController!

    override func setUp() {
        super.setUp()
        sut = ThemeController(store: MockThemeStore())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testChangingTheme() {
        // given
        let theme = Theme.dark
        // when
        sut.changeTheme(to: theme)
        // then
        XCTAssertEqual(sut.currentTheme, .dark)
    }

    func testControllerShouldReturnLightThemeWhenLoadForTheFirstTime() {
        // when
        let theme = sut.currentTheme
        // then
        XCTAssertEqual(theme, sut.currentTheme)
    }

    func testUINavigationBarTintColorShouldApplyDarkThemeWhenItWasSet() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let navBarColor = UINavigationBar.appearance().tintColor
        XCTAssertEqual(navBarColor!, Theme.dark.style.titleTextColor)
    }

    func testUINavigationBarStyleShouldChangeToBlackWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let barStyle = UINavigationBar.appearance().barStyle
        XCTAssertEqual(barStyle, Theme.dark.style.barStyle)
    }

    func testUINavigationBarIsTranslucentShouldChangeToFalseWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let isNavBarTranslucent = UINavigationBar.appearance().isTranslucent
        XCTAssertEqual(isNavBarTranslucent, Theme.dark.style.navigationBarIsTranslucent)
    }

    func testUIBarButtonTintColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let barButtonItemTintColor = UIBarButtonItem.appearance().tintColor
        XCTAssertEqual(barButtonItemTintColor, Theme.dark.style.titleTextColor)
    }

    func testUITableViewCellBackgroundColorShouldChangeToBackgroundColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let tableViewCellBackgroundColor = UITableViewCell.appearance().backgroundColor
        XCTAssertEqual(tableViewCellBackgroundColor, Theme.dark.style.backgroundColor)
    }

    func testUITableViewCellSelectedBackgroundColorShouldChangeToCellSelectedBackgroundViewColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let tableViewCellSelectedBackgroundColor = UITableViewCell.appearance().selectedBackgroundView?.backgroundColor
        XCTAssertEqual(tableViewCellSelectedBackgroundColor!, Theme.dark.style.cellSelectedBackgroundViewColor)
    }

    func testUIScrollViewBackgroundColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let scrollViewBackgroundColor = UIScrollView.appearance().backgroundColor
        XCTAssertEqual(scrollViewBackgroundColor, Theme.dark.style.backgroundColor)
    }

    func testUIToolBarTintColorShouldChangeToBackgroundColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let barTintColor = UIToolbar.appearance().barTintColor
        XCTAssertEqual(barTintColor, Theme.dark.style.toolBarBackgroundColor)
    }

    func testSettingsFooterViewVersionTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let versionTextColor = SettingsFooterView.appearance().versionTextColor
        XCTAssertEqual(versionTextColor, Theme.dark.style.titleTextColor)
    }

    func testSettingsFooterViewBuildTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let buildTextColor = SettingsFooterView.appearance().versionTextColor
        XCTAssertEqual(buildTextColor, Theme.dark.style.titleTextColor)
    }

    func testRuleTableViewCellRuleTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let ruleTextColor = RuleTableViewCell.appearance().ruleTextColor
        XCTAssertEqual(ruleTextColor, Theme.dark.style.titleTextColor)
    }

    func testRuleDetailTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let ruleDescriptionTextColor = RuleDescriptionLabel.appearance().descriptionTextColor
        XCTAssertEqual(ruleDescriptionTextColor, Theme.dark.style.titleTextColor)
    }

    func testTweetTableViewCellHandleLabelTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let handleLabelTextColor = TweetTableViewCell.appearance().handleLabelTextColor
        XCTAssertEqual(handleLabelTextColor, Theme.dark.style.thirdTitleTextColor)
    }

    func testTweetTableViewCellDateLabelTextColorShouldChangeToSecondaryTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let dateLabelTextColor = TweetTableViewCell.appearance().dateLabelTextColor
        XCTAssertEqual(dateLabelTextColor, Theme.dark.style.secondaryTitleTextColor)
    }

    func testTweetTableViewCellLinkTintColorShouldChangeToSecondaryTintColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let linkTintColor = TweetTableViewCell.appearance().linkTintColor
        XCTAssertEqual(linkTintColor, Theme.dark.style.tintColor)
    }

    func testUITextViewTextColorShouldChangeToSecondaryTintColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let textViewTextColor = UITextView.appearance(whenContainedInInstancesOf: [TweetTableViewCell.self]).textColor
        XCTAssertEqual(textViewTextColor, Theme.dark.style.titleTextColor)
    }

    func testChatInputViewSendMessageBGButtonColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let chatInputViewSendMessageColor = SendButton.appearance().sendMessageButtonBGColor
        XCTAssertEqual(chatInputViewSendMessageColor, Theme.dark.style.titleTextColor)
    }

    func testChatMessageTableViewCellTimeLabelTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let timeLabelTextColor = ChatMessageTableViewCell.appearance().timeLabelTextColor
        XCTAssertEqual(timeLabelTextColor, Theme.dark.style.titleTextColor)
    }

    func testChatMessageTableViewCellChatTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let chatTextColor = ChatMessageTableViewCell.appearance().chatTextColor
        XCTAssertEqual(chatTextColor, Theme.dark.style.secondaryTitleTextColor)
    }

    func testSeperatorViewBackgroundColorShouldChangeToNavigationOverlaySeperatorColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let backgroundColor = SeparatorView.appearance().backgroundColor
        XCTAssertEqual(backgroundColor, Theme.dark.style.separatorColor)
    }

    func testChatNavigationButtonUnreadMessagesBackgroundColorShouldChangeToRedWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let backgroundColor = ChatNavigationButton.appearance().unreadMessagesBackgroundColor
        XCTAssertEqual(backgroundColor, UIColor.red)
    }

    func testUIRefreshControlTintColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let tintColor = UIRefreshControl.appearance().tintColor
        XCTAssertEqual(tintColor, Theme.dark.style.titleTextColor)
    }

    func testUITextViewTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let textColor = UITextView.appearance().textColor
        XCTAssertEqual(textColor, Theme.dark.style.titleTextColor)
    }

    func testUITableViewTintColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = UITableView.appearance().tintColor
        XCTAssertEqual(color, Theme.dark.style.titleTextColor)
    }

    func testNoContentMessageLabelMessageTextColorShouldChangeToTitleTextColorWhenNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = NoContentMessageLabel.appearance().messageTextColor
        XCTAssertEqual(color, Theme.dark.style.titleTextColor)
    }

    func testUILabelTextTextColorShouldBeWhiteWhenContainedInChatNavigationButtonAndNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = UILabel.appearance(whenContainedInInstancesOf: [ChatNavigationButton.self]).textColor
        XCTAssertEqual(color, UIColor.white)
    }

    func testUILabelTextTextColorShouldChangeToTitleTextColorWhenContainedInUITableViewHeaderFooterViewAndNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor
        XCTAssertEqual(color, Theme.dark.style.titleTextColor)
    }

    func testUILabelTextTextColorShouldChangeToTitleTextColorWhenContainedInTweetTableViewCellAndNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = UILabel.appearance(whenContainedInInstancesOf: [TweetTableViewCell.self]).textColor
        XCTAssertEqual(color, Theme.dark.style.titleTextColor)
    }

    func testUILabelBackgroundColorShouldChangeToBackgroundColorWhenContainedInUITableViewHeaderFooterViewAndNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor
        XCTAssertEqual(color, Theme.dark.style.backgroundColor)
    }

    func testUIViewBackgroundColorShouldChangeToBackgroundColorWhenContainedInNavigationOverlayViewControllerAndNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = OverlayView.appearance().overlayBackgroundColor
        XCTAssertEqual(color, Theme.dark.style.navigationOverlayBackgroundColor)
    }

    func testCustomButtonTintColorShouldChangeToTitleTextColorWhenContainedInNavigationOverlayViewControllerAndNightModeWasSelected() {
        // given
        let theme: Theme = .dark
        // when
        sut.changeTheme(to: theme)
        sut.applyTheme()
        // then
        let color = CustomButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).defaultTintColor
        XCTAssertEqual(color, Theme.dark.style.titleTextColor)
    }

    func testChatNavigationButtonTextColorShouldAlwaysBeWhite() {
        // given
        let nightTheme: Theme = .dark
        let lightTheme: Theme = .light
        // when
        sut.changeTheme(to: nightTheme)
        sut.applyTheme()
        let darkColor = ChatNavigationButton.appearance().unreadMessagesTextColor

        sut.changeTheme(to: lightTheme)
        sut.applyTheme()
        let lightColor = ChatNavigationButton.appearance().unreadMessagesTextColor
        // then
        XCTAssertEqual(darkColor, .white)
        XCTAssertEqual(lightColor, .white)
    }

    func testChatNavigationButtonBackgroundColorShouldAlwaysBeRed() {
        // given
        let nightTheme: Theme = .dark
        let lightTheme: Theme = .light
        // when
        sut.changeTheme(to: nightTheme)
        sut.applyTheme()
        let darkColor = ChatNavigationButton.appearance().unreadMessagesBackgroundColor

        sut.changeTheme(to: lightTheme)
        sut.applyTheme()
        let lightColor = ChatNavigationButton.appearance().unreadMessagesBackgroundColor
        // then
        XCTAssertEqual(darkColor, .red)
        XCTAssertEqual(lightColor, .red)
    }

    func testCustomButtonTintColorShouldChangeToTitleTextColorWhenContainedInNavigationOverlayViewControllerAndNightModeWasSelectedAndChangeAgainWhenLightThemeIsSelected() {
        // given
        let nightTheme: Theme = .dark
        let lightTheme: Theme = .light
        // when
        sut.changeTheme(to: nightTheme)
        sut.applyTheme()
        let nightColor = CustomButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).defaultTintColor

        sut.changeTheme(to: lightTheme)
        sut.applyTheme()
        let lightColor = CustomButton.appearance(whenContainedInInstancesOf: [NavigationOverlayViewController.self]).defaultTintColor
        // then
        XCTAssertEqual(nightColor, Theme.dark.style.titleTextColor)
        XCTAssertEqual(lightColor, Theme.light.style.titleTextColor)
    }
}
