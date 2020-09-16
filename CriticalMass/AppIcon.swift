//
// Created for CriticalMaps in 2020

import Foundation
import UIKit

enum AppIcon: String, CaseIterable {
    case light, dark, rainbow, yellow, neon

    var name: String {
        String(rawValue.prefix(1).uppercased() + rawValue.dropFirst())
    }

    private var fileName: String {
        switch self {
        case .dark:
            return "CMDarkIcon@3x"
        case .rainbow:
            return "CMRainbowIcon@3x"
        case .yellow:
            return "CMYellowIcon@3x"
        case .neon:
            return "CMNeonIcon@3x"
        case .light:
            return "CMAppLogo"
        }
    }

    var image: UIImage? {
        switch self {
        case .dark, .neon, .rainbow, .yellow:
            var documentsUrl: URL {
                FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            }
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "png") else { return nil }
            let imageData = try? Data(contentsOf: url)
            return imageData.flatMap { UIImage(data: $0) }
        case .light:
            return UIImage(named: fileName).flatMap { $0 }
        }
    }
}
