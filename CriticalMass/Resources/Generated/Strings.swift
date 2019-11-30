// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Fehler
  internal static let error = L10n.tr("Localizable", "error")

  internal enum Chat {
    /// Zurzeit keine Nachrichten...
    internal static let noChatActivity = L10n.tr("Localizable", "chat.noChatActivity")
    /// Nachricht ...
    internal static let placeholder = L10n.tr("Localizable", "chat.placeholder")
    /// senden
    internal static let send = L10n.tr("Localizable", "chat.send")
    /// Chat
    internal static let title = L10n.tr("Localizable", "chat.title")
    internal enum Send {
      /// Die Nachricht konnte nicht versendet werden. Bitte versuche es erneut.
      internal static let error = L10n.tr("Localizable", "chat.send.error")
    }
  }

  internal enum Close {
    internal enum Button {
      /// schließen
      internal static let label = L10n.tr("Localizable", "close.button.label")
    }
  }

  internal enum ErrorState {
    /// Entschuldige, irgendwas ging schief
    internal static let message = L10n.tr("Localizable", "errorState.message")
    /// Error
    internal static let title = L10n.tr("Localizable", "errorState.title")
  }

  internal enum Map {
    /// Critical Maps
    internal static let title = L10n.tr("Localizable", "map.title")
    internal enum Layer {
      /// Critical Maps muss dein GPS verwenden, um die Karte anderen aktiven Benutzer anzuzeigen
      internal static let info = L10n.tr("Localizable", "map.layer.info")
      internal enum Info {
        /// GPS deaktiviert
        internal static let title = L10n.tr("Localizable", "map.layer.info.title")
      }
    }
    internal enum LocationButton {
      /// Ortung
      internal static let label = L10n.tr("Localizable", "map.locationButton.label")
    }
  }

  internal enum Rules {
    /// Knigge
    internal static let title = L10n.tr("Localizable", "rules.title")
    internal enum Text {
      /// Wenn's mal nicht anders geht, versuche die anderen per Handzeichen zu warnen.
      internal static let brake = L10n.tr("Localizable", "rules.text.brake")
      /// Verzichte darauf auf der Gegenfahrbahn zu fahren.
      internal static let contraflow = L10n.tr("Localizable", "rules.text.contraflow")
      /// Schütze Autofahrer vor sich selbst durch corken!
      internal static let cork = L10n.tr("Localizable", "rules.text.cork")
      /// Vorne: nicht rasen!\nHinten, Lücken zufahren!
      internal static let gently = L10n.tr("Localizable", "rules.text.gently")
      /// Wenn du an der Spitze der Mass fährst, musst du warten bis die Ampel auf Grün schaltet.
      internal static let green = L10n.tr("Localizable", "rules.text.green")
      /// Genieße autofreie Straßen. Fahr ein bisschen mit den Sound-Rädern mit. Check die Bikes deiner Mitfahrer aus. Quatsch Autofahrer, Passanten, Mitfahrer an. Hab Spaß!
      internal static let haveFun = L10n.tr("Localizable", "rules.text.haveFun")
      /// Lass dich nicht provozieren. Sei freundlich zur Polizei und zu Autofahrern, auch wenn die's nicht sind.
      internal static let stayLoose = L10n.tr("Localizable", "rules.text.stayLoose")
    }
    internal enum Title {
      /// Keine Vollbremsungen
      internal static let brake = L10n.tr("Localizable", "rules.title.brake")
      /// Gegenverkehr
      internal static let contraflow = L10n.tr("Localizable", "rules.title.contraflow")
      /// Corken!?
      internal static let cork = L10n.tr("Localizable", "rules.title.cork")
      /// Sachte, Keule!
      internal static let gently = L10n.tr("Localizable", "rules.title.gently")
      /// Vorne nur bei Grün
      internal static let green = L10n.tr("Localizable", "rules.title.green")
      /// Hab Spaß!
      internal static let haveFun = L10n.tr("Localizable", "rules.title.haveFun")
      /// Locker bleiben
      internal static let stayLoose = L10n.tr("Localizable", "rules.title.stayLoose")
    }
  }

  internal enum Settings {
    /// About
    internal static let about = L10n.tr("Localizable", "settings.about")
    /// Design
    internal static let appDesign = L10n.tr("Localizable", "settings.appDesign")
    /// Critical Mass Berlin
    internal static let cmBerlin = L10n.tr("Localizable", "settings.cmBerlin")
    /// Helfe unseren Server zu finanzieren
    internal static let donate = L10n.tr("Localizable", "settings.donate")
    /// Facebook
    internal static let facebook = L10n.tr("Localizable", "settings.facebook")
    /// GPS Einstellungen
    internal static let gpsSettings = L10n.tr("Localizable", "settings.gpsSettings")
    /// Knigge Bilder
    internal static let kniggeImages = L10n.tr("Localizable", "settings.kniggeImages")
    /// Logo design
    internal static let logoDesign = L10n.tr("Localizable", "settings.logoDesign")
    /// Github
    internal static let openSource = L10n.tr("Localizable", "settings.openSource")
    /// Development
    internal static let programming = L10n.tr("Localizable", "settings.programming")
    /// Social Media
    internal static let socialMedia = L10n.tr("Localizable", "settings.socialMedia")
    /// Nachtmodus
    internal static let theme = L10n.tr("Localizable", "settings.theme")
    /// Einstellungen
    internal static let title = L10n.tr("Localizable", "settings.title")
    /// Twitter
    internal static let twitter = L10n.tr("Localizable", "settings.twitter")
    /// Website
    internal static let website = L10n.tr("Localizable", "settings.website")
    internal enum Observationmode {
      /// Wenn du nicht selbst teilnimmst, aber trotzdem der Critical Mass folgen möchtest.
      internal static let detail = L10n.tr("Localizable", "settings.observationmode.detail")
      /// Beobachtungsmodus
      internal static let title = L10n.tr("Localizable", "settings.observationmode.title")
    }
    internal enum Opensource {
      /// Projekt ansehen
      internal static let action = L10n.tr("Localizable", "settings.opensource.action")
      /// Critical Maps ist ein Open Source Projekt und wir feuen uns über Entwickler*innen die an Critical Maps mitarbeiten wollen.
      internal static let detail = L10n.tr("Localizable", "settings.opensource.detail")
      /// Vermisst du Funktionen oder willst einen Bug fixen?
      internal static let title = L10n.tr("Localizable", "settings.opensource.title")
    }
    internal enum Section {
      /// Info
      internal static let info = L10n.tr("Localizable", "settings.section.info")
    }
  }

  internal enum Twitter {
    /// Momentan sind keine Tweets verfügbar.\nBitte ziehen um neue zu laden.
    internal static let noData = L10n.tr("Localizable", "twitter.noData")
    /// Twitter
    internal static let title = L10n.tr("Localizable", "twitter.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
