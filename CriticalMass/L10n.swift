//
// Created for CriticalMaps in 2020

import Foundation

enum L10n {
    static let twitterNoData = L10n.translate("twitter.noData")
    static let rulesTitle = L10n.translate("rules.title")
    static let rulesNumber = L10n.translate("rules.number")
    static let error = L10n.translate("error")
    static let closeButtonLabel = L10n.translate("close.button.label")
    static let loadingButtonLabel = L10n.translate("loadintton.label")
    static let ok = L10n.translate("ok")
    // Settings
    static let appIconTitle = L10n.translate("settings.appIconTitle")
    static let themeLocalizedString = L10n.translate("settings.theme")
    static let themeAppearanceLocalizedString = L10n.translate("settings.theme.appearance")
    static let themeSystemLocalizedString = L10n.translate("settings.theme.system")
    static let themeLightLocalizedString = L10n.translate("settings.theme.light")
    static let themeDarkLocalizedString = L10n.translate("settings.theme.dark")
    static let obversationModeTitle = L10n.translate("settings.observationmode.title")
    static let obversationModeDetail = L10n.translate("settings.observationmode.detail")
    static let settingsTitle = L10n.translate("settings.title")
    static let settingsSectionInfo = L10n.translate("settings.section.info")
    static let settingsWebsite = L10n.translate("settings.website")
    static let settingsTwitter = L10n.translate("settings.twitter")
    static let settingsFacebook = L10n.translate("settings.facebook")
    static let settingsOpenSourceTitle = L10n.translate("settings.opensource.title")
    static let settingsOpenSourceDetail = L10n.translate("settings.opensource.detail")
    static let settingsOpenSourceAction = L10n.translate("settings.opensource.action")
    static let settingsCriticalMassDotInTitle = L10n.translate("settings.criticalMassDotIn.title")
    static let settingsCriticalMassDotInDetail = L10n.translate("settings.criticalMassDotIn.detail")
    static let settingsCriticalMassDotInAction = L10n.translate("settings.criticalMassDotIn.action")
    static let settingsFriends = L10n.translate("settings.friends")
    static let settingsFriendsSettings = L10n.translate("settings.friends.settings")
    static let settingsFriendsShowID = L10n.translate("settings.friends.showID")
    static let settingsAddFriendTitle = L10n.translate("settings.friends.addFriendTitle")
    static let settingsAddFriendDescription = L10n.translate("settings.friends.addFriendDescription")
    static let settingsEventSettings = L10n.translate("settings.eventSettings")
    static let settingsEventSearchRadius = L10n.translate("settings.eventSearchRadius")
    static let settingsEventSettingsEnable = L10n.translate("settings.eventSettingsEnable")
    static let settingsEventSettingsTypes = L10n.translate("settings.eventTypes")
    static func settingsEventSearchRadiusDistance(_ p1: Any) -> String {
        L10n.translate("settings.eventSearchRadiusDistance", String(describing: p1))
    }

    static let settingsAppIcon = L10n.translate("settings.appIcon")
    // Chat
    static let chatNoChatActivity = L10n.translate("chat.noChatActivity")
    static let chatPlaceholder = L10n.translate("chat.placeholder")
    static let chatSend = L10n.translate("chat.send")
    static let chatTitle = L10n.translate("chat.title")
    static let chatSendError = L10n.translate("chat.send.error")
    static func chatUnreadButtonAccessibilityValue(count: String) -> String { L10n.translate("chat.unreadbutton.accessibilityvalue", count)
    }

    // Map
    static let mapLayerInfo = L10n.translate("map.layer.info")
    static let mapLayerInfoTitle = L10n.translate("map.layer.info.title")
    static let mapTitle = L10n.translate("map.title")
    static let mapHeadingButtonAccessibilityLabel = L10n.translate("map.headingbutton.accessibilitylabel")
    static let mapHeadingButtonAccessibilityValueOff = L10n.translate("map.headingbutton.accessibilityvalue.off")
    static let mapHeadingButtonAccessibilityValueOn = L10n.translate("map.headingbutton.accessibilityvalue.on")
    static let mapHeadingButtonAccessibilityValueOnWithHeading = L10n.translate("map.headingbutton.accessibilityvalue.heading")
    // ErrorState
    static let errorStateTitle = L10n.translate("errorState.title")
    static let errorStateMessage = L10n.translate("errorState.message")
    // Map action items
    static let menuTitle = L10n.translate("map.menu.title")
    static let menuShare = L10n.translate("map.menu.share")
    static let menuRoute = L10n.translate("map.menu.route")
}

extension L10n {
    private static func translate(_ key: String, tableName: String = "Localizable", _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: tableName, comment: "")
        return String(format: format, locale: .current, arguments: args)
    }
}
