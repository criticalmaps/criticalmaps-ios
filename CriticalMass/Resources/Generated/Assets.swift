// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
    import AppKit.NSImage
    internal typealias AssetColorTypeAlias = NSColor
    internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    internal typealias AssetColorTypeAlias = UIColor
    internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
    internal static let arrow = ImageAsset(name: "Arrow")
    internal static let arrowButton = ImageAsset(name: "ArrowButton")
    internal static let avatar = ImageAsset(name: "Avatar")
    internal static let backgroundLaunch = ImageAsset(name: "Background_Launch")
    internal static let bike = ImageAsset(name: "Bike")
    internal static let brake = ImageAsset(name: "Brake")
    internal static let bubble = ImageAsset(name: "Bubble")
    internal static let bubbleActive = ImageAsset(name: "Bubble_Active")
    internal static let cmAppLogo = ImageAsset(name: "CMAppLogo")
    internal static let chat = ImageAsset(name: "Chat")
    internal static let close = ImageAsset(name: "Close")
    internal static let contraflow = ImageAsset(name: "Contraflow")
    internal static let cork = ImageAsset(name: "Cork")
    internal static let donate = ImageAsset(name: "Donate")
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
    internal static let paypal = ImageAsset(name: "Paypal")
    internal static let punk = ImageAsset(name: "Punk")
    internal static let reload = ImageAsset(name: "Reload")
    internal static let settings = ImageAsset(name: "Settings")
    internal static let settingsActive = ImageAsset(name: "Settings_Active")
    internal static let stayLoose = ImageAsset(name: "StayLoose")
    internal static let twitter = ImageAsset(name: "Twitter")
    internal static let twitterActive = ImageAsset(name: "Twitter_Active")
    internal static let iconSend = ImageAsset(name: "icon-send")
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
    internal fileprivate(set) var name: String

    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
    internal var color: AssetColorTypeAlias {
        AssetColorTypeAlias(asset: self)
    }
}

internal extension AssetColorTypeAlias {
    @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
    convenience init!(asset: ColorAsset) {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: NSColor.Name(asset.name), bundle: bundle)
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

internal struct DataAsset {
    internal fileprivate(set) var name: String

    #if os(iOS) || os(tvOS) || os(OSX)
        @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
        internal var data: NSDataAsset {
            NSDataAsset(asset: self)
        }
    #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
    @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
    internal extension NSDataAsset {
        convenience init!(asset: DataAsset) {
            let bundle = Bundle(for: BundleToken.self)
            #if os(iOS) || os(tvOS)
                self.init(name: asset.name, bundle: bundle)
            #elseif os(OSX)
                self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
            #endif
        }
    }
#endif

internal struct ImageAsset {
    internal fileprivate(set) var name: String

    internal var image: AssetImageTypeAlias {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS)
            let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.image(forResource: NSImage.Name(name))
        #elseif os(watchOS)
            let image = AssetImageTypeAlias(named: name)
        #endif
        guard let result = image else { fatalError("Unable to load image named \(name).") }
        return result
    }
}

internal extension AssetImageTypeAlias {
    @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
    @available(OSX, deprecated,
               message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init!(asset: ImageAsset) {
        #if os(iOS) || os(tvOS)
            let bundle = Bundle(for: BundleToken.self)
            self.init(named: asset.name, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: NSImage.Name(asset.name))
        #elseif os(watchOS)
            self.init(named: asset.name)
        #endif
    }
}

private final class BundleToken {}
