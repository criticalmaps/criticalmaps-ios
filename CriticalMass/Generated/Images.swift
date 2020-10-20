// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#elseif os(tvOS) || os(watchOS)
    import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
    internal static let arrow = ImageAsset(name: "Arrow")
    internal static let arrowButton = ImageAsset(name: "ArrowButton")
    internal static let avatar = ImageAsset(name: "Avatar")
    internal static let backgroundLaunch = ImageAsset(name: "Background_Launch")
    internal static let brake = ImageAsset(name: "Brake")
    internal static let bubble = ImageAsset(name: "Bubble")
    internal static let bubbleActive = ImageAsset(name: "Bubble_Active")
    internal static let cmAppLogo = ImageAsset(name: "CMAppLogo")
    internal static let chat = ImageAsset(name: "Chat")
    internal static let close = ImageAsset(name: "Close")
    internal static let contraflow = ImageAsset(name: "Contraflow")
    internal static let cork = ImageAsset(name: "Cork")
    internal static let gently = ImageAsset(name: "Gently")
    internal static let githubBanner = ImageAsset(name: "GithubBanner")
    internal static let green = ImageAsset(name: "Green")
    internal static let haveFun = ImageAsset(name: "HaveFun")
    internal static let knigge = ImageAsset(name: "Knigge")
    internal static let list = ImageAsset(name: "List")
    internal static let listActive = ImageAsset(name: "List_Active")
    internal static let location = ImageAsset(name: "Location")
    internal static let locationActive = ImageAsset(name: "LocationActive")
    internal static let locationHeading = ImageAsset(name: "LocationHeading")
    internal static let logo = ImageAsset(name: "Logo")
    internal static let map = ImageAsset(name: "Map")
    internal static let mapActive = ImageAsset(name: "Map_Active")
    internal static let punk = ImageAsset(name: "Punk")
    internal static let reload = ImageAsset(name: "Reload")
    internal static let settings = ImageAsset(name: "Settings")
    internal static let settingsActive = ImageAsset(name: "Settings_Active")
    internal static let stayLoose = ImageAsset(name: "StayLoose")
    internal static let twitter = ImageAsset(name: "Twitter")
    internal static let twitterActive = ImageAsset(name: "Twitter_Active")
    internal static let alert = ImageAsset(name: "alert")
    internal static let bannerCm = ImageAsset(name: "banner cm")
    internal static let eventMarker = ImageAsset(name: "event-marker")
    internal static let iconClose = ImageAsset(name: "icon-close")
    internal static let iconSend = ImageAsset(name: "icon-send")
    internal static let info = ImageAsset(name: "info")
    internal static let logoM = ImageAsset(name: "logo-m")
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
    internal fileprivate(set) var name: String

    #if os(macOS)
        internal typealias Image = NSImage
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        internal typealias Image = UIImage
    #endif

    internal var image: Image {
        let bundle = BundleToken.bundle
        #if os(iOS) || os(tvOS)
            let image = Image(named: name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            let name = NSImage.Name(self.name)
            let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
        #elseif os(watchOS)
            let image = Image(named: name)
        #endif
        guard let result = image else {
            fatalError("Unable to load image named \(name).")
        }
        return result
    }
}

internal extension ImageAsset.Image {
    @available(macOS, deprecated,
               message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init!(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
            let bundle = BundleToken.bundle
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(macOS)
            self.init(named: NSImage.Name(asset.name))
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        Bundle(for: BundleToken.self)
    }()
}

// swiftlint:enable convenience_type
