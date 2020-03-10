//
// Created for CriticalMaps in 2020

import Foundation

enum L10n {
    static let twitterNoData = L10n.tr("twitter.noData")
    static let rulesTitle = L10n.tr("rules.title")
    static let error = L10n.tr("error")
    static let closeButtonLabel = L10n.tr("close.button.label")
    static let loadingButtonLabel = L10n.tr("loadintton.label")
    static let ok = L10n.tr("ok")
    // Settings
    static let themeLocalizedString = L10n.tr("settings.theme")
    static let obversationModeTitle = L10n.tr("settings.observationmode.title")
    static let obversationModeDetail = L10n.tr("settings.observationmode.detail")
    static let settingsTitle = L10n.tr("settings.title")
    static let settingsSectionInfo = L10n.tr("settings.section.info")
    static let settingsWebsite = L10n.tr("settings.website")
    static let settingsTwitter = L10n.tr("settings.twitter")
    static let settingsFacebook = L10n.tr("settings.facebook")
    static let settingsOpenSourceTitle = L10n.tr("settings.opensource.title")
    static let settingsOpenSourceDetail = L10n.tr("settings.opensource.detail")
    static let settingsOpenSourceAction = L10n.tr("settings.opensource.action")
    static let settingsCriticalMassDotInTitle = L10n.tr("settings.criticalMassDotIn.title")
    static let settingsCriticalMassDotInDetail = L10n.tr("settings.criticalMassDotIn.detail")
    static let settingsFriends = L10n.tr("settings.friends")
    static let settingsFriendsSettings = L10n.tr("settings.friends.settings")
    static let settingsFriendsShowID = L10n.tr("settings.friends.showID")
    static let settingsAddFriendTitle = L10n.tr("settings.friends.addFriendTitle")
    static let settingsAddFriendDescription = L10n.tr("settings.friends.addFriendDescription")
    // Chat
    static let chatNoChatActivity = L10n.tr("chat.noChatActivity")
    static let chatPlaceholder = L10n.tr("chat.placeholder")
    static let chatSend = L10n.tr("chat.send")
    static let chatTitle = L10n.tr("chat.title")
    static let chatSendError = L10n.tr("chat.send.error")
    // Map
    static let mapLayerInfo = L10n.tr("map.layer.info")
    static let mapLayerInfoTitle = L10n.tr("map.layer.info.title")
    static let mapTitle = L10n.tr("map.title")
    // ErrorState
    static let errorStateTitle = L10n.tr("errorState.title")
    static let errorStateMessage = L10n.tr("errorState.message")
}

extension L10n {
    private static func tr(_ key: String, tableName: String = "Localizable", _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: tableName, comment: "")
        return String(format: format, locale: .current, arguments: args)
    }
}
