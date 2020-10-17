// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")

  internal enum Chat {
    /// Nobody's chatting at the moment...\nwhy don't you start?
    internal static let noChatActivity = L10n.tr("Localizable", "chat.noChatActivity")
    /// Write Message
    internal static let placeholder = L10n.tr("Localizable", "chat.placeholder")
    /// Send
    internal static let send = L10n.tr("Localizable", "chat.send")
    /// Chat
    internal static let title = L10n.tr("Localizable", "chat.title")
    internal enum Send {
      /// The message could not be sent. Please try again.
      internal static let error = L10n.tr("Localizable", "chat.send.error")
    }
    internal enum Unreadbutton {
      /// %@ unread messages
      internal static func accessibilityvalue(_ p1: Any) -> String {
        return L10n.tr("Localizable", "chat.unreadbutton.accessibilityvalue", String(describing: p1))
      }
    }
  }

  internal enum Close {
    internal enum Button {
      /// close
      internal static let label = L10n.tr("Localizable", "close.button.label")
    }
  }

  internal enum ErrorState {
    /// Sorry, something went wrong
    internal static let message = L10n.tr("Localizable", "errorState.message")
    /// Error
    internal static let title = L10n.tr("Localizable", "errorState.title")
  }

  internal enum Map {
    /// Critical Maps
    internal static let title = L10n.tr("Localizable", "map.title")
    internal enum Headingbutton {
      /// Tracking
      internal static let accessibilitylabel = L10n.tr("Localizable", "map.headingbutton.accessibilitylabel")
      internal enum Accessibilityvalue {
        /// On with heading
        internal static let heading = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.heading")
        /// Off
        internal static let off = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.off")
        /// On
        internal static let on = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.on")
      }
    }
    internal enum Layer {
      /// Critical Maps needs to use your GPS to show the map with other active user
      internal static let info = L10n.tr("Localizable", "map.layer.info")
      internal enum Info {
        /// Server does not respond
        internal static let errorMessage = L10n.tr("Localizable", "map.layer.info.errorMessage")
        /// GPS deactivated
        internal static let title = L10n.tr("Localizable", "map.layer.info.title")
      }
    }
    internal enum LocationButton {
      /// locating
      internal static let label = L10n.tr("Localizable", "map.locationButton.label")
    }
    internal enum Menu {
      /// Route
      internal static let route = L10n.tr("Localizable", "map.menu.route")
      /// Share
      internal static let share = L10n.tr("Localizable", "map.menu.share")
      /// Next event
      internal static let title = L10n.tr("Localizable", "map.menu.title")
    }
  }

  internal enum Rules {
    /// Rule Number
    internal static let number = L10n.tr("Localizable", "rules.number")
    /// Rules
    internal static let title = L10n.tr("Localizable", "rules.title")
    internal enum Text {
      /// Avoid sudden stops. If you really have to though, try to warn people behind you.
      internal static let brake = L10n.tr("Localizable", "rules.text.brake")
      /// Refrain from driving in the opposite lane.
      internal static let contraflow = L10n.tr("Localizable", "rules.text.contraflow")
      /// Protect motorists from themselves by corking!\n\nTo maintain the cohesion of the group, block traffic from side roads so that the mass can freely proceed through red lights without interruptions.
      internal static let cork = L10n.tr("Localizable", "rules.text.cork")
      /// When driving in the front: No speeding!\n\nWhen driving in the rear: Close gaps!
      internal static let gently = L10n.tr("Localizable", "rules.text.gently")
      /// When you arrive at a red light while driving as part of the head of the mass, be sure to stop when the traffic light shows red.
      internal static let green = L10n.tr("Localizable", "rules.text.green")
      /// Enjoy reclaimed streets. Check out the Sound Bikes. Chat with motorists and pedestrian to let them know what's going on.\n\nAnd most importantly: Have fun!
      internal static let haveFun = L10n.tr("Localizable", "rules.text.haveFun")
      /// Don't allow yourself to be provoked. Be friendly to the police, motorists and everybody else, even if they are not.
      internal static let stayLoose = L10n.tr("Localizable", "rules.text.stayLoose")
    }
    internal enum Title {
      /// No hard stops!
      internal static let brake = L10n.tr("Localizable", "rules.title.brake")
      /// Careful of oncoming traffic
      internal static let contraflow = L10n.tr("Localizable", "rules.title.contraflow")
      /// Corking!?
      internal static let cork = L10n.tr("Localizable", "rules.title.cork")
      /// Hold your horses!
      internal static let gently = L10n.tr("Localizable", "rules.title.gently")
      /// When driving at the head: Stop at the redlights!
      internal static let green = L10n.tr("Localizable", "rules.title.green")
      /// Have fun!
      internal static let haveFun = L10n.tr("Localizable", "rules.title.haveFun")
      /// Hang loose
      internal static let stayLoose = L10n.tr("Localizable", "rules.title.stayLoose")
    }
  }

  internal enum Settings {
    /// About
    internal static let about = L10n.tr("Localizable", "settings.about")
    /// Design
    internal static let appDesign = L10n.tr("Localizable", "settings.appDesign")
    /// App Icon
    internal static let appIcon = L10n.tr("Localizable", "settings.appIcon")
    /// App Icon
    internal static let appIconTitle = L10n.tr("Localizable", "settings.appIconTitle")
    /// Critical Mass Berlin
    internal static let cmBerlin = L10n.tr("Localizable", "settings.cmBerlin")
    /// Help finacing our tracking server
    internal static let donate = L10n.tr("Localizable", "settings.donate")
    /// Event Search Radius
    internal static let eventSearchRadius = L10n.tr("Localizable", "settings.eventSearchRadius")
    /// %@ km
    internal static func eventSearchRadiusDistance(_ p1: Any) -> String {
      return L10n.tr("Localizable", "settings.eventSearchRadiusDistance", String(describing: p1))
    }
    /// Event Settings
    internal static let eventSettings = L10n.tr("Localizable", "settings.eventSettings")
    /// Enable Event Notifications
    internal static let eventSettingsEnable = L10n.tr("Localizable", "settings.eventSettingsEnable")
    /// Event Types
    internal static let eventTypes = L10n.tr("Localizable", "settings.eventTypes")
    /// Facebook
    internal static let facebook = L10n.tr("Localizable", "settings.facebook")
    /// Friends
    internal static let friends = L10n.tr("Localizable", "settings.friends")
    /// GPS settings
    internal static let gpsSettings = L10n.tr("Localizable", "settings.gpsSettings")
    /// Rules images
    internal static let kniggeImages = L10n.tr("Localizable", "settings.kniggeImages")
    /// Logo design
    internal static let logoDesign = L10n.tr("Localizable", "settings.logoDesign")
    /// Github
    internal static let openSource = L10n.tr("Localizable", "settings.openSource")
    /// Development
    internal static let programming = L10n.tr("Localizable", "settings.programming")
    /// Event Search Radius
    internal static let settingsEventSearchRadius = L10n.tr("Localizable", "settings.settingsEventSearchRadius")
    /// Social Media
    internal static let socialMedia = L10n.tr("Localizable", "settings.socialMedia")
    /// Night mode
    internal static let theme = L10n.tr("Localizable", "settings.theme")
    /// Settings
    internal static let title = L10n.tr("Localizable", "settings.title")
    /// Twitter
    internal static let twitter = L10n.tr("Localizable", "settings.twitter")
    /// Website
    internal static let website = L10n.tr("Localizable", "settings.website")
    internal enum CriticalMassDotIn {
      /// View Project
      internal static let action = L10n.tr("Localizable", "settings.criticalMassDotIn.action")
      /// Submit your bike activism to the criticalmass.in project and promote it to other bike enthusiasts.
      internal static let detail = L10n.tr("Localizable", "settings.criticalMassDotIn.detail")
      /// Missing a mass?
      internal static let title = L10n.tr("Localizable", "settings.criticalMassDotIn.title")
    }
    internal enum Friends {
      /// added
      internal static let addFriendDescription = L10n.tr("Localizable", "settings.friends.addFriendDescription")
      /// Added Friend
      internal static let addFriendTitle = L10n.tr("Localizable", "settings.friends.addFriendTitle")
      /// Settings
      internal static let settings = L10n.tr("Localizable", "settings.friends.settings")
      /// Show ID
      internal static let showID = L10n.tr("Localizable", "settings.friends.showID")
    }
    internal enum Observationmode {
      /// If you don’t take part yourself, but want to follow the Critical Mass.
      internal static let detail = L10n.tr("Localizable", "settings.observationmode.detail")
      /// Observation Mode
      internal static let title = L10n.tr("Localizable", "settings.observationmode.title")
    }
    internal enum Opensource {
      /// View Repository
      internal static let action = L10n.tr("Localizable", "settings.opensource.action")
      /// Critical Maps is an open source project and we are looking forward to developers who want to work on critical maps.
      internal static let detail = L10n.tr("Localizable", "settings.opensource.detail")
      /// Do you miss features or want to fix a bug?
      internal static let title = L10n.tr("Localizable", "settings.opensource.title")
    }
    internal enum Section {
      /// Info
      internal static let info = L10n.tr("Localizable", "settings.section.info")
    }
    internal enum Theme {
      /// Appearance
      internal static let appearance = L10n.tr("Localizable", "settings.theme.appearance")
      /// Dark
      internal static let dark = L10n.tr("Localizable", "settings.theme.dark")
      /// Light
      internal static let light = L10n.tr("Localizable", "settings.theme.light")
      /// System
      internal static let system = L10n.tr("Localizable", "settings.theme.system")
    }
  }

  internal enum Twitter {
    /// No data is currently available.\nPlease pull down to refresh.
    internal static let noData = L10n.tr("Localizable", "twitter.noData")
    /// Twitter
    internal static let title = L10n.tr("Localizable", "twitter.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
