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
  public enum AppIntent {
    public enum ObservationMode {
      /// Enable or disable observation mode in CriticalMaps
      public static let description = L10n.tr("Localizable", "appIntent.observationMode.description", fallback: "Enable or disable observation mode in CriticalMaps")
      /// Toggle Observation Mode
      public static let title = L10n.tr("Localizable", "appIntent.observationMode.title", fallback: "Toggle Observation Mode")
      public enum Parameter {
        /// Whether to enable or disable observation mode
        public static let description = L10n.tr("Localizable", "appIntent.observationMode.parameter.description", fallback: "Whether to enable or disable observation mode")
        /// Enable Observation Mode
        public static let title = L10n.tr("Localizable", "appIntent.observationMode.parameter.title", fallback: "Enable Observation Mode")
      }
      public enum Result {
        /// Observation mode disabled
        public static let disabled = L10n.tr("Localizable", "appIntent.observationMode.result.disabled", fallback: "Observation mode disabled")
        /// Observation mode enabled
        public static let enabled = L10n.tr("Localizable", "appIntent.observationMode.result.enabled", fallback: "Observation mode enabled")
      }
      public enum Shortcut {
        /// Observation Mode
        public static let title = L10n.tr("Localizable", "appIntent.observationMode.shortcut.title", fallback: "Observation Mode")
        public enum Phrase {
          /// Disable observation mode in %@
          public static func disable(_ p1: Any) -> String {
            return L10n.tr("Localizable", "appIntent.observationMode.shortcut.phrase.disable", String(describing: p1), fallback: "Disable observation mode in %@")
          }
          /// Enable observation mode in %@
          public static func enable(_ p1: Any) -> String {
            return L10n.tr("Localizable", "appIntent.observationMode.shortcut.phrase.enable", String(describing: p1), fallback: "Enable observation mode in %@")
          }
          /// Toggle observation mode in %@
          public static func toggle(_ p1: Any) -> String {
            return L10n.tr("Localizable", "appIntent.observationMode.shortcut.phrase.toggle", String(describing: p1), fallback: "Toggle observation mode in %@")
          }
          /// Turn off observation mode in %@
          public static func turnOff(_ p1: Any) -> String {
            return L10n.tr("Localizable", "appIntent.observationMode.shortcut.phrase.turnOff", String(describing: p1), fallback: "Turn off observation mode in %@")
          }
          /// Turn on observation mode in %@
          public static func turnOn(_ p1: Any) -> String {
            return L10n.tr("Localizable", "appIntent.observationMode.shortcut.phrase.turnOn", String(describing: p1), fallback: "Turn on observation mode in %@")
          }
        }
      }
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
  public enum AppearanceSettings {
    public enum ThemePicker {
      /// Select Theme
      public static let label = L10n.tr("Localizable", "appearanceSettings.themePicker.label", fallback: "Select Theme")
      /// Theme
      public static let sectionHeader = L10n.tr("Localizable", "appearanceSettings.themePicker.sectionHeader", fallback: "Theme")
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
  public enum Home {
    public enum Tab {
      public enum Social {
        /// Unread messages: %@
        public static func unreadMessages(_ p1: Any) -> String {
          return L10n.tr("Localizable", "home.tab.social.unreadMessages", String(describing: p1), fallback: "Unread messages: %@")
        }
      }
    }
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
    public enum Location {
      public enum Request {
        /// Location makes this app better. Please consider giving us access.
        public static let desciption = L10n.tr("Localizable", "map.location.request.desciption", fallback: "Location makes this app better. Please consider giving us access.")
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
  public enum PrivacyZone {
    public enum Settings {
      /// Privacy Zone Settings
      public static let navigationTitle = L10n.tr("Localizable", "privacyZone.settings.navigationTitle", fallback: "Privacy Zone Settings")
      public enum Create {
        /// Create Privacy Zone
        public static let navigationTitle = L10n.tr("Localizable", "privacyZone.settings.create.navigationTitle", fallback: "Create Privacy Zone")
        public enum Cta {
          /// Create
          public static let create = L10n.tr("Localizable", "privacyZone.settings.create.cta.create", fallback: "Create")
        }
        public enum Map {
          /// Choose Location
          public static let headline = L10n.tr("Localizable", "privacyZone.settings.create.map.headline", fallback: "Choose Location")
          /// Radius
          public static let radius = L10n.tr("Localizable", "privacyZone.settings.create.map.radius", fallback: "Radius")
          /// Tap on the map to set the center of your privacy zone
          public static let subheadline = L10n.tr("Localizable", "privacyZone.settings.create.map.subheadline", fallback: "Tap on the map to set the center of your privacy zone")
          public enum Name {
            /// Zone Name
            public static let headline = L10n.tr("Localizable", "privacyZone.settings.create.map.name.headline", fallback: "Zone Name")
            /// e.g., Home
            public static let placeholder = L10n.tr("Localizable", "privacyZone.settings.create.map.name.placeholder", fallback: "e.g., Home")
          }
        }
      }
      public enum Dialog {
        /// Are you sure you want to delete the privacy zone '%@'?
        /// This action cannot be undone.
        public static func message(_ p1: Any) -> String {
          return L10n.tr("Localizable", "privacyZone.settings.dialog.message", String(describing: p1), fallback: "Are you sure you want to delete the privacy zone '%@'?\nThis action cannot be undone.")
        }
        public enum Cta {
          /// Cancel
          public static let cancel = L10n.tr("Localizable", "privacyZone.settings.dialog.cta.cancel", fallback: "Cancel")
          /// Delete
          public static let delete = L10n.tr("Localizable", "privacyZone.settings.dialog.cta.delete", fallback: "Delete")
        }
        public enum Delete {
          /// Delete Privacy Zone
          public static let headline = L10n.tr("Localizable", "privacyZone.settings.dialog.delete.headline", fallback: "Delete Privacy Zone")
        }
      }
      public enum Disabled {
        /// Enable Privacy Zones
        public static let cta = L10n.tr("Localizable", "privacyZone.settings.disabled.cta", fallback: "Enable Privacy Zones")
        /// Privacy Zones
        public static let headline = L10n.tr("Localizable", "privacyZone.settings.disabled.headline", fallback: "Privacy Zones")
        /// Create zones where your location won't be shared with other riders
        public static let subheadline = L10n.tr("Localizable", "privacyZone.settings.disabled.subheadline", fallback: "Create zones where your location won't be shared with other riders")
      }
      public enum Empty {
        /// No privacy zones created yet
        public static let headline = L10n.tr("Localizable", "privacyZone.settings.empty.headline", fallback: "No privacy zones created yet")
        /// Create your first zone to start protecting your privacy
        public static let subheadline = L10n.tr("Localizable", "privacyZone.settings.empty.subheadline", fallback: "Create your first zone to start protecting your privacy")
      }
      public enum Section {
        /// Privacy zones prevent your location from being shared when you're within the defined area.
        public static let footer = L10n.tr("Localizable", "privacyZone.settings.section.footer", fallback: "Privacy zones prevent your location from being shared when you're within the defined area.")
        /// Settings
        public static let header = L10n.tr("Localizable", "privacyZone.settings.section.header", fallback: "Settings")
        /// Your Privacy Zones
        public static let yourZones = L10n.tr("Localizable", "privacyZone.settings.section.yourZones", fallback: "Your Privacy Zones")
      }
      public enum Toggle {
        /// Enable Privacy Zones
        public static let enableFeature = L10n.tr("Localizable", "privacyZone.settings.toggle.enableFeature", fallback: "Enable Privacy Zones")
        /// Show Zones on Map
        public static let showZonesOnMap = L10n.tr("Localizable", "privacyZone.settings.toggle.showZonesOnMap", fallback: "Show Zones on Map")
      }
    }
    public enum Tile {
      public enum StatusText {
        /// Location Hidden
        public static let hidden = L10n.tr("Localizable", "privacyZone.tile.statusText.hidden", fallback: "Location Hidden")
        /// Privacy Zones Off
        public static let off = L10n.tr("Localizable", "privacyZone.tile.statusText.off", fallback: "Privacy Zones Off")
        /// Privacy Zones On
        public static let on = L10n.tr("Localizable", "privacyZone.tile.statusText.on", fallback: "Privacy Zones On")
      }
    }
  }
  public enum RideEventSettings {
    public enum RideTypes {
      /// Select which types of ride events you'd like to be notified about when they occur near your location.
      public static let footer = L10n.tr("Localizable", "rideEventSettings.rideTypes.footer", fallback: "Select which types of ride events you'd like to be notified about when they occur near your location.")
    }
    public enum SearchRadius {
      /// Choose how far around your location to search for ride events. A larger radius will show more events but may include those less relevant to your ride.
      public static let footer = L10n.tr("Localizable", "rideEventSettings.searchRadius.footer", fallback: "Choose how far around your location to search for ride events. A larger radius will show more events but may include those less relevant to your ride.")
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
    public enum Info {
      public enum Toggle {
        /// Show info toogle over the map
        public static let description = L10n.tr("Localizable", "settings.info.toggle.description", fallback: "Show info toogle over the map")
        /// Show info view
        public static let label = L10n.tr("Localizable", "settings.info.toggle.label", fallback: "Show info view")
      }
    }
    public enum Navigation {
      public enum PrivacySettings {
        /// Privacy Zones
        public static let label = L10n.tr("Localizable", "settings.navigation.privacySettings.label", fallback: "Privacy Zones")
      }
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
  public enum Social {
    public enum Error {
      /// Failed to fetch chat messages
      public static let fetchMessages = L10n.tr("Localizable", "social.error.fetchMessages", fallback: "Failed to fetch chat messages")
      /// Failed to send chat message
      public static let sendMessage = L10n.tr("Localizable", "social.error.sendMessage", fallback: "Failed to send chat message")
    }
    public enum Feed {
      /// Loading Feed
      public static let loading = L10n.tr("Localizable", "social.feed.loading", fallback: "Loading Feed")
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
