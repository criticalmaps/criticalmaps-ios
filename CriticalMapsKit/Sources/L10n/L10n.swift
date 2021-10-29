import Foundation

public enum L10n {
  /// Error
  public static let error = L10n.tr("Localizable", "error")
  /// OK
  public static let ok = L10n.tr("Localizable", "ok")
  
  public enum Chat {
    /// Nobody's chatting at the moment...\nwhy don't you start?
    public static let noChatActivity = L10n.tr("Localizable", "chat.noChatActivity")
    /// Write Message
    public static let placeholder = L10n.tr("Localizable", "chat.placeholder")
    /// Send
    public static let send = L10n.tr("Localizable", "chat.send")
    /// Chat
    public static let title = L10n.tr("Localizable", "chat.title")
    public enum Send {
      /// The message could not be sent. Please try again.
      public static let error = L10n.tr("Localizable", "chat.send.error")
    }
    public enum Unreadbutton {
      /// %@ unread messages
      public static func accessibilityvalue(_ p1: Any) -> String {
        return L10n.tr("Localizable", "chat.unreadbutton.accessibilityvalue", String(describing: p1))
      }
    }
  }
  
  public enum Close {
    public enum Button {
      /// close
      public static let label = L10n.tr("Localizable", "close.button.label")
    }
  }
  
  public enum ErrorState {
    /// Sorry, something went wrong
    public static let message = L10n.tr("Localizable", "errorState.message")
    /// Error
    public static let title = L10n.tr("Localizable", "errorState.title")
  }
  
  public enum Map {
    /// Critical Maps
    public static let title = L10n.tr("Localizable", "map.title")
    public enum Headingbutton {
      /// Tracking
      public static let accessibilitylabel = L10n.tr("Localizable", "map.headingbutton.accessibilitylabel")
      public enum Accessibilityvalue {
        /// On with heading
        public static let heading = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.heading")
        /// Off
        public static let off = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.off")
        /// On
        public static let on = L10n.tr("Localizable", "map.headingbutton.accessibilityvalue.on")
      }
    }
    public enum Layer {
      /// Critical Maps needs to use your GPS to show the map with other active user
      public static let info = L10n.tr("Localizable", "map.layer.info")
      public enum Info {
        /// Critical Maps isn't updating. Please check back later.
        public static let errorMessage = L10n.tr("Localizable", "map.layer.info.errorMessage")
        /// GPS deactivated
        public static let title = L10n.tr("Localizable", "map.layer.info.title")
      }
    }
    public enum LocationButton {
      /// locating
      public static let label = L10n.tr("Localizable", "map.locationButton.label")
    }
    public enum Menu {
      /// Route
      public static let route = L10n.tr("Localizable", "map.menu.route")
      /// Share
      public static let share = L10n.tr("Localizable", "map.menu.share")
      /// Next event
      public static let title = L10n.tr("Localizable", "map.menu.title")
    }
  }
  
  public enum Rules {
    /// Rule Number
    public static let number = L10n.tr("Localizable", "rules.number")
    /// Rules
    public static let title = L10n.tr("Localizable", "rules.title")
    public enum Text {
      /// Avoid sudden stops. If you really have to though, try to warn people behind you.
      public static let brake = L10n.tr("Localizable", "rules.text.brake")
      /// Refrain from driving in the opposite lane.
      public static let contraflow = L10n.tr("Localizable", "rules.text.contraflow")
      /// Protect motorists from themselves by corking!\n\nTo maintain the cohesion of the group, block traffic from side roads so that the mass can freely proceed through red lights without interruptions.
      public static let cork = L10n.tr("Localizable", "rules.text.cork")
      /// When driving in the front: No speeding!\n\nWhen driving in the rear: Close gaps!
      public static let gently = L10n.tr("Localizable", "rules.text.gently")
      /// When you arrive at a red light while driving as part of the head of the mass, be sure to stop when the traffic light shows red.
      public static let green = L10n.tr("Localizable", "rules.text.green")
      /// Enjoy reclaimed streets. Check out the Sound Bikes. Chat with motorists and pedestrian to let them know what's going on.\n\nAnd most importantly: Have fun!
      public static let haveFun = L10n.tr("Localizable", "rules.text.haveFun")
      /// Don't allow yourself to be provoked. Be friendly to the police, motorists and everybody else, even if they are not.
      public static let stayLoose = L10n.tr("Localizable", "rules.text.stayLoose")
    }
    public enum Title {
      /// No hard stops!
      public static let brake = L10n.tr("Localizable", "rules.title.brake")
      /// Careful of oncoming traffic
      public static let contraflow = L10n.tr("Localizable", "rules.title.contraflow")
      /// Corking!?
      public static let cork = L10n.tr("Localizable", "rules.title.cork")
      /// Hold your horses!
      public static let gently = L10n.tr("Localizable", "rules.title.gently")
      /// When driving at the head: Stop at the redlights!
      public static let green = L10n.tr("Localizable", "rules.title.green")
      /// Have fun!
      public static let haveFun = L10n.tr("Localizable", "rules.title.haveFun")
      /// Hang loose
      public static let stayLoose = L10n.tr("Localizable", "rules.title.stayLoose")
    }
  }
  
  public enum Settings {
    /// About
    public static let about = L10n.tr("Localizable", "settings.about")
    /// Design
    public static let appDesign = L10n.tr("Localizable", "settings.appDesign")
    /// App Icon
    public static let appIcon = L10n.tr("Localizable", "settings.appIcon")
    /// App Icon
    public static let appIconTitle = L10n.tr("Localizable", "settings.appIconTitle")
    /// Critical Mass Berlin
    public static let cmBerlin = L10n.tr("Localizable", "settings.cmBerlin")
    /// Help finacing our tracking server
    public static let donate = L10n.tr("Localizable", "settings.donate")
    /// Event Search Radius
    public static let eventSearchRadius = L10n.tr("Localizable", "settings.eventSearchRadius")
    /// %@ km
    public static func eventSearchRadiusDistance(_ p1: Any) -> String {
      return L10n.tr("Localizable", "settings.eventSearchRadiusDistance", String(describing: p1))
    }
    /// Event Settings
    public static let eventSettings = L10n.tr("Localizable", "settings.eventSettings")
    /// Enable Event Notifications
    public static let eventSettingsEnable = L10n.tr("Localizable", "settings.eventSettingsEnable")
    /// Event Types
    public static let eventTypes = L10n.tr("Localizable", "settings.eventTypes")
    /// Facebook
    public static let facebook = L10n.tr("Localizable", "settings.facebook")
    /// Friends
    public static let friends = L10n.tr("Localizable", "settings.friends")
    /// GPS settings
    public static let gpsSettings = L10n.tr("Localizable", "settings.gpsSettings")
    /// Rules images
    public static let kniggeImages = L10n.tr("Localizable", "settings.kniggeImages")
    /// Logo design
    public static let logoDesign = L10n.tr("Localizable", "settings.logoDesign")
    /// Github
    public static let openSource = L10n.tr("Localizable", "settings.openSource")
    /// Development
    public static let programming = L10n.tr("Localizable", "settings.programming")
    /// Event Search Radius
    public static let settingsEventSearchRadius = L10n.tr("Localizable", "settings.settingsEventSearchRadius")
    /// Social Media
    public static let socialMedia = L10n.tr("Localizable", "settings.socialMedia")
    /// Night mode
    public static let theme = L10n.tr("Localizable", "settings.theme")
    /// Settings
    public static let title = L10n.tr("Localizable", "settings.title")
    /// Twitter
    public static let twitter = L10n.tr("Localizable", "settings.twitter")
    /// Website
    public static let website = L10n.tr("Localizable", "settings.website")
    public enum CriticalMassDotIn {
      /// View Project
      public static let action = L10n.tr("Localizable", "settings.criticalMassDotIn.action")
      /// Submit your bike activism to the criticalmass.in project and promote it to other bike enthusiasts.
      public static let detail = L10n.tr("Localizable", "settings.criticalMassDotIn.detail")
      /// Missing a mass?
      public static let title = L10n.tr("Localizable", "settings.criticalMassDotIn.title")
    }
    public enum Friends {
      /// added
      public static let addFriendDescription = L10n.tr("Localizable", "settings.friends.addFriendDescription")
      /// Added Friend
      public static let addFriendTitle = L10n.tr("Localizable", "settings.friends.addFriendTitle")
      /// Settings
      public static let settings = L10n.tr("Localizable", "settings.friends.settings")
      /// Show ID
      public static let showID = L10n.tr("Localizable", "settings.friends.showID")
    }
    public enum Observationmode {
      /// If you don’t take part yourself, but want to follow the Critical Mass.
      public static let detail = L10n.tr("Localizable", "settings.observationmode.detail")
      /// Observation Mode
      public static let title = L10n.tr("Localizable", "settings.observationmode.title")
    }
    public enum Opensource {
      /// View Repository
      public static let action = L10n.tr("Localizable", "settings.opensource.action")
      /// Critical Maps is an open source project and we are looking forward to developers who want to work on critical maps.
      public static let detail = L10n.tr("Localizable", "settings.opensource.detail")
      /// Do you miss features or want to fix a bug?
      public static let title = L10n.tr("Localizable", "settings.opensource.title")
    }
    public enum Section {
      /// Info
      public static let info = L10n.tr("Localizable", "settings.section.info")
    }
    public enum Theme {
      /// Appearance
      public static let appearance = L10n.tr("Localizable", "settings.theme.appearance")
      /// Dark
      public static let dark = L10n.tr("Localizable", "settings.theme.dark")
      /// Light
      public static let light = L10n.tr("Localizable", "settings.theme.light")
      /// System
      public static let system = L10n.tr("Localizable", "settings.theme.system")
    }
  }
  
  public enum Twitter {
    /// No data is currently available.\nPlease pull down to refresh.
    public static let noData = L10n.tr("Localizable", "twitter.noData")
    /// Twitter
    public static let title = L10n.tr("Localizable", "twitter.title")
    /// Here you’ll find tweets tagged with @criticalmaps and #criticalmass
    public static let emptyMessage = L10n.tr("Localizable", "twitter.empty.message")
  }
  
  public enum Location {
    public enum Alert {
      /// Bitte geben Sie uns in den Einstellungen Zugriff auf Ihren Standort.
      public static let provideAccessToLocationService = L10n.tr("Localizable", "location.alert.provideAccessToLocationService")
      /// Die Standortnutzung macht diese App besser. Bitte geben Sie uns Zugang.
      public static let provideAuth = L10n.tr("Localizable", "location.alert.provideAuth")
      /// Ortungsdienste sind deaktiviert.
      public static let serviceIsOff = L10n.tr("Localizable", "location.alert.serviceIsOff")
    }
  }
}

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
  
  private final class BundleToken {
    static let bundle = Bundle.module
  }
}
