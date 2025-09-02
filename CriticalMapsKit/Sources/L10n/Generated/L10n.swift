// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Error
  public static let error = L10n.tr("Localizable", "error", fallback: "Error")
  /// OK
  public static let ok = L10n.tr("Localizable", "ok", fallback: "OK")
  public enum A11y {
    public enum ChatInput {
      /// Chat input textfield
      public static let label = L10n.tr("Localizable", "a11y.chatInput.label", fallback: "Chat input textfield")
    }
    public enum General {
      /// Off
      public static let off = L10n.tr("Localizable", "a11y.general.off", fallback: "Off")
      /// On
      public static let on = L10n.tr("Localizable", "a11y.general.on", fallback: "On")
      /// selected
      public static let selected = L10n.tr("Localizable", "a11y.general.selected", fallback: "selected")
    }
    public enum Mapfeatureview {
      public enum Nextridebanner {
        /// Shows the next critical mass event closest to your location
        public static let hint = L10n.tr("Localizable", "a11y.mapfeatureview.nextridebanner.hint", fallback: "Shows the next critical mass event closest to your location")
        /// Next critical mass banner
        public static let label = L10n.tr("Localizable", "a11y.mapfeatureview.nextridebanner.label", fallback: "Next critical mass banner")
      }
    }
    public enum Usertrackingbutton {
      /// Don't follow
      public static let dontFollow = L10n.tr("Localizable", "a11y.usertrackingbutton.dontFollow", fallback: "Don't follow")
      /// Follow
      public static let follow = L10n.tr("Localizable", "a11y.usertrackingbutton.follow", fallback: "Follow")
      /// Follow with heading
      public static let followWithHeading = L10n.tr("Localizable", "a11y.usertrackingbutton.followWithHeading", fallback: "Follow with heading")
      /// Toggle tracking mode
      public static let hint = L10n.tr("Localizable", "a11y.usertrackingbutton.hint", fallback: "Toggle tracking mode")
    }
  }
  public enum AppCore {
    public enum ViewingModeAlert {
      /// Are you participating in the Critical Mass or are you only watching?
      public static let message = L10n.tr("Localizable", "appCore.viewingModeAlert.message", fallback: "Are you participating in the Critical Mass or are you only watching?")
      /// Riding
      public static let riding = L10n.tr("Localizable", "appCore.viewingModeAlert.riding", fallback: "Riding")
      /// Viewing Mode
      public static let title = L10n.tr("Localizable", "appCore.viewingModeAlert.title", fallback: "Viewing Mode")
      /// Watching
      public static let watching = L10n.tr("Localizable", "appCore.viewingModeAlert.watching", fallback: "Watching")
    }
  }
  public enum AppView {
    public enum Overlay {
      /// Next update
      public static let nextUpdate = L10n.tr("Localizable", "appView.overlay.nextUpdate", fallback: "Next update")
      /// Riders
      public static let riders = L10n.tr("Localizable", "appView.overlay.riders", fallback: "Riders")
    }
  }
  public enum Chat {
    /// So quiet here
    public static let emptyMessageTitle = L10n.tr("Localizable", "chat.emptyMessageTitle", fallback: "So quiet here")
    /// Nobody's chatting at the moment...
    /// why don't you start?
    public static let noChatActivity = L10n.tr("Localizable", "chat.noChatActivity", fallback: "Nobody's chatting at the moment...\nwhy don't you start?")
    /// Write Message
    public static let placeholder = L10n.tr("Localizable", "chat.placeholder", fallback: "Write Message")
    /// Send
    public static let send = L10n.tr("Localizable", "chat.send", fallback: "Send")
    /// Chat
    public static let title = L10n.tr("Localizable", "chat.title", fallback: "Chat")
    public enum Send {
      /// The message could not be sent. Please try again.
      public static let error = L10n.tr("Localizable", "chat.send.error", fallback: "The message could not be sent. Please try again.")
    }
    public enum Unreadbutton {
      /// %@ unread messages
      public static func accessibilityvalue(_ p1: Any) -> String {
        return L10n.tr("Localizable", "chat.unreadbutton.accessibilityvalue", String(describing: p1), fallback: "%@ unread messages")
      }
    }
  }
  public enum Close {
    public enum Button {
      /// close
      public static let label = L10n.tr("Localizable", "close.button.label", fallback: "close")
    }
  }
  public enum EmptyState {
    /// Reload
    public static let reload = L10n.tr("Localizable", "emptyState.reload", fallback: "Reload")
  }
  public enum ErrorState {
    /// Sorry, something went wrong
    public static let message = L10n.tr("Localizable", "errorState.message", fallback: "Sorry, something went wrong")
    /// ErrorState
    public static let title = L10n.tr("Localizable", "errorState.title", fallback: "Error")
  }
  public enum Location {
    public enum Alert {
      /// Please give us access to your location in settings.
      public static let provideAccessToLocationService = L10n.tr("Localizable", "location.alert.provideAccessToLocationService", fallback: "Please give us access to your location in settings.")
      /// Location usage makes this app better. Please give us access.
      public static let provideAuth = L10n.tr("Localizable", "location.alert.provideAuth", fallback: "Location usage makes this app better. Please give us access.")
      /// Location services are disabled.
      public static let serviceIsOff = L10n.tr("Localizable", "location.alert.serviceIsOff", fallback: "Location services are disabled.")
    }
  }
  public enum Map {
    /// Critical Maps
    public static let title = L10n.tr("Localizable", "map.title", fallback: "Critical Maps")
    public enum Headingbutton {
      /// Tracking
      public static let accessibilitylabel = L10n.tr("Localizable", "map.headingbutton.accessibilitylabel", fallback: "Tracking")
      public enum Accessibilityvalue {
        /// On with heading
        public static let heading = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.heading", fallback: "On with heading")
        /// Off
        public static let off = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.off", fallback: "Off")
        /// On
        public static let on = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.on", fallback: "On")
      }
    }
    public enum Layer {
      /// Critical Maps needs to use your GPS to show the map with other active user
      public static let info = L10n.tr("Localizable", "map.layer.info", fallback: "Critical Maps needs to use your GPS to show the map with other active user")
      public enum Info {
        /// Critical Maps isn't updating. Please check back later.
        public static let errorMessage = L10n.tr("Localizable", "map.layer.info.errorMessage", fallback: "Critical Maps isn't updating. Please check back later.")
        /// GPS deactivated
        public static let title = L10n.tr("Localizable", "map.layer.info.title", fallback: "GPS deactivated")
      }
    }
    public enum LocationButton {
      /// locating
      public static let label = L10n.tr("Localizable", "map.locationButton.label", fallback: "locating")
    }
    public enum Menu {
      /// Route
      public static let route = L10n.tr("Localizable", "map.menu.route", fallback: "Route")
      /// Share
      public static let share = L10n.tr("Localizable", "map.menu.share", fallback: "Share")
      /// Next event
      public static let title = L10n.tr("Localizable", "map.menu.title", fallback: "Next event")
    }
    public enum NextRideEvents {
      /// Hide events
      public static let hideAll = L10n.tr("Localizable", "map.nextRideEvents.hideAll", fallback: "Hide events")
      /// Show events
      public static let showAll = L10n.tr("Localizable", "map.nextRideEvents.showAll", fallback: "Show events")
    }
  }
  public enum Rules {
    /// Rule Number
    public static let number = L10n.tr("Localizable", "rules.number", fallback: "Rule Number")
    /// Rules
    public static let title = L10n.tr("Localizable", "rules.title", fallback: "Rules")
    public enum Text {
      /// Avoid sudden stops. If you really have to though, try to warn people behind you.
      public static let brake = L10n.tr("Localizable", "rules.text.brake", fallback: "Avoid sudden stops. If you really have to though, try to warn people behind you.")
      /// Refrain from driving in the opposite lane.
      public static let contraflow = L10n.tr("Localizable", "rules.text.contraflow", fallback: "Refrain from driving in the opposite lane.")
      /// Protect motorists from themselves by corking!
      /// 
      /// To maintain the cohesion of the group, block traffic from side roads so that the mass can freely proceed through red lights without interruptions.
      public static let cork = L10n.tr("Localizable", "rules.text.cork", fallback: "Protect motorists from themselves by corking!\n\nTo maintain the cohesion of the group, block traffic from side roads so that the mass can freely proceed through red lights without interruptions.")
      /// When driving in the front: No speeding!
      /// 
      /// When driving in the rear: Close gaps!
      public static let gently = L10n.tr("Localizable", "rules.text.gently", fallback: "When driving in the front: No speeding!\n\nWhen driving in the rear: Close gaps!")
      /// When you arrive at a red light while driving as part of the head of the mass, be sure to stop when the traffic light shows red.
      public static let green = L10n.tr("Localizable", "rules.text.green", fallback: "When you arrive at a red light while driving as part of the head of the mass, be sure to stop when the traffic light shows red.")
      /// Enjoy reclaimed streets. Check out the Sound Bikes. Chat with motorists and pedestrian to let them know what's going on.
      /// 
      /// And most importantly: Have fun!
      public static let haveFun = L10n.tr("Localizable", "rules.text.haveFun", fallback: "Enjoy reclaimed streets. Check out the Sound Bikes. Chat with motorists and pedestrian to let them know what's going on.\n\nAnd most importantly: Have fun!")
      /// Don't allow yourself to be provoked. Be friendly to the police, motorists and everybody else, even if they are not.
      public static let stayLoose = L10n.tr("Localizable", "rules.text.stayLoose", fallback: "Don't allow yourself to be provoked. Be friendly to the police, motorists and everybody else, even if they are not.")
    }
    public enum Title {
      /// No hard stops!
      public static let brake = L10n.tr("Localizable", "rules.title.brake", fallback: "No hard stops!")
      /// Careful of oncoming traffic
      public static let contraflow = L10n.tr("Localizable", "rules.title.contraflow", fallback: "Careful of oncoming traffic")
      /// Corking!?
      public static let cork = L10n.tr("Localizable", "rules.title.cork", fallback: "Corking!?")
      /// Hold your horses!
      public static let gently = L10n.tr("Localizable", "rules.title.gently", fallback: "Hold your horses!")
      /// When driving at the head: Stop at the redlights!
      public static let green = L10n.tr("Localizable", "rules.title.green", fallback: "When driving at the head: Stop at the redlights!")
      /// Have fun!
      public static let haveFun = L10n.tr("Localizable", "rules.title.haveFun", fallback: "Have fun!")
      /// Hang loose
      public static let stayLoose = L10n.tr("Localizable", "rules.title.stayLoose", fallback: "Hang loose")
    }
  }
  public enum Settings {
    /// About
    public static let about = L10n.tr("Localizable", "settings.about", fallback: "About")
    /// Design
    public static let appDesign = L10n.tr("Localizable", "settings.appDesign", fallback: "Design")
    /// App Icon
    public static let appIcon = L10n.tr("Localizable", "settings.appIcon", fallback: "App Icon")
    /// App Icon
    public static let appIconTitle = L10n.tr("Localizable", "settings.appIconTitle", fallback: "App Icon")
    /// Critical Mass Berlin
    public static let cmBerlin = L10n.tr("Localizable", "settings.cmBerlin", fallback: "Critical Mass Berlin")
    /// Help finacing our tracking server
    public static let donate = L10n.tr("Localizable", "settings.donate", fallback: "Help finacing our tracking server")
    /// Event Search Radius
    public static let eventSearchRadius = L10n.tr("Localizable", "settings.eventSearchRadius", fallback: "Event Search Radius")
    /// %@ km
    public static func eventSearchRadiusDistance(_ p1: Any) -> String {
      return L10n.tr("Localizable", "settings.eventSearchRadiusDistance", String(describing: p1), fallback: "%@ km")
    }
    /// Event Settings
    public static let eventSettings = L10n.tr("Localizable", "settings.eventSettings", fallback: "Event Settings")
    /// Event Notifications
    public static let eventSettingsEnable = L10n.tr("Localizable", "settings.eventSettingsEnable", fallback: "Event Notifications")
    /// Event Types
    public static let eventTypes = L10n.tr("Localizable", "settings.eventTypes", fallback: "Event Types")
    /// Facebook
    public static let facebook = L10n.tr("Localizable", "settings.facebook", fallback: "Facebook")
    /// Friends
    public static let friends = L10n.tr("Localizable", "settings.friends", fallback: "Friends")
    /// GPS settings
    public static let gpsSettings = L10n.tr("Localizable", "settings.gpsSettings", fallback: "GPS settings")
    /// Rules images
    public static let kniggeImages = L10n.tr("Localizable", "settings.kniggeImages", fallback: "Rules images")
    /// Logo design
    public static let logoDesign = L10n.tr("Localizable", "settings.logoDesign", fallback: "Logo design")
    /// Github
    public static let openSource = L10n.tr("Localizable", "settings.openSource", fallback: "Github")
    /// Privacy Policy
    public static let privacyPolicy = L10n.tr("Localizable", "settings.privacyPolicy", fallback: "Privacy Policy")
    /// Development
    public static let programming = L10n.tr("Localizable", "settings.programming", fallback: "Development")
    /// Event Search Radius
    public static let settingsEventSearchRadius = L10n.tr("Localizable", "settings.settingsEventSearchRadius", fallback: "Event Search Radius")
    /// Social Media
    public static let socialMedia = L10n.tr("Localizable", "settings.socialMedia", fallback: "Social Media")
    /// Support
    public static let support = L10n.tr("Localizable", "settings.support", fallback: "Support")
    /// Theme
    public static let theme = L10n.tr("Localizable", "settings.theme", fallback: "Night mode")
    /// Settings
    public static let title = L10n.tr("Localizable", "settings.title", fallback: "Settings")
    /// Twitter
    public static let twitter = L10n.tr("Localizable", "settings.twitter", fallback: "Twitter")
    /// Website
    public static let website = L10n.tr("Localizable", "settings.website", fallback: "Website")
    public enum CriticalMassDotIn {
      /// View Project
      public static let action = L10n.tr("Localizable", "settings.criticalMassDotIn.action", fallback: "View Project")
      /// Submit your bike activism to the criticalmass.in project and promote it to other bike enthusiasts.
      public static let detail = L10n.tr("Localizable", "settings.criticalMassDotIn.detail", fallback: "Submit your bike activism to the criticalmass.in project and promote it to other bike enthusiasts.")
      /// Missing a mass?
      public static let title = L10n.tr("Localizable", "settings.criticalMassDotIn.title", fallback: "Missing a mass?")
    }
    public enum Friends {
      /// added
      public static let addFriendDescription = L10n.tr("Localizable", "settings.friends.addFriendDescription", fallback: "added")
      /// Added Friend
      public static let addFriendTitle = L10n.tr("Localizable", "settings.friends.addFriendTitle", fallback: "Added Friend")
      /// Settings
      public static let settings = L10n.tr("Localizable", "settings.friends.settings", fallback: "Settings")
      /// Show ID
      public static let showID = L10n.tr("Localizable", "settings.friends.showID", fallback: "Show ID")
    }
    public enum Observationmode {
      /// If you don’t take part yourself, but want to follow the Critical Mass.
      public static let detail = L10n.tr("Localizable", "settings.observationmode.detail", fallback: "If you don’t take part yourself, but want to follow the Critical Mass.")
      /// Observation Mode
      public static let title = L10n.tr("Localizable", "settings.observationmode.title", fallback: "Observation Mode")
    }
    public enum Opensource {
      /// View Repository
      public static let action = L10n.tr("Localizable", "settings.opensource.action", fallback: "View Repository")
      /// Critical Maps is an open source project and we are looking forward to developers who want to work on critical maps.
      public static let detail = L10n.tr("Localizable", "settings.opensource.detail", fallback: "Critical Maps is an open source project and we are looking forward to developers who want to work on critical maps.")
      /// Do you miss features or want to fix a bug?
      public static let title = L10n.tr("Localizable", "settings.opensource.title", fallback: "Do you miss features or want to fix a bug?")
    }
    public enum Section {
      /// Info
      public static let info = L10n.tr("Localizable", "settings.section.info", fallback: "Info")
    }
    public enum Theme {
      /// Theme appearance
      public static let appearance = L10n.tr("Localizable", "settings.theme.appearance", fallback: "Appearance")
      /// Theme appearance dark
      public static let dark = L10n.tr("Localizable", "settings.theme.dark", fallback: "Dark")
      /// Theme appearance light
      public static let light = L10n.tr("Localizable", "settings.theme.light", fallback: "Light")
      /// Theme appearance system
      public static let system = L10n.tr("Localizable", "settings.theme.system", fallback: "System")
    }
    public enum Translate {
      /// crowdin.com
      public static let link = L10n.tr("Localizable", "settings.translate.link", fallback: "crowdin.com")
      /// Help making Critical Maps available in other languages
      public static let subtitle = L10n.tr("Localizable", "settings.translate.subtitle", fallback: "Help making Critical Maps available in other languages")
      /// Translate
      public static let title = L10n.tr("Localizable", "settings.translate.title", fallback: "Translate")
    }
  }
  public enum Twitter {
    /// Nothing here at the momemt
    public static let noData = L10n.tr("Localizable", "twitter.noData", fallback: "Nothing here at the momemt")
    /// Twitter
    public static let title = L10n.tr("Localizable", "twitter.title", fallback: "Twitter")
    public enum Empty {
      /// Here you’ll find tweets tagged with @criticalmaps and #criticalmass
      public static let message = L10n.tr("Localizable", "twitter.empty.message", fallback: "Here you’ll find tweets tagged with @criticalmaps and #criticalmass")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
