//
//  XCTestCase+SnapshotTests.swift
//  CriticalMapsSnapshotTests
//
//  Created by MAXIM TSVETKOV on 05.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import SnapshotTesting
import XCTest

private let operatingSystemVersion = ProcessInfo().operatingSystemVersion

extension XCTestCase {
    func assertViewSnapshot(
        for themes: [Theme] = [.light, .dark],
        matching value: UIView,
        with size: CGSize? = nil,
        precision: Float = 1,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        localized: Bool = true
    ) {
        enforceSnapshotDevice()

        themes.forEach { theme in
            MockThemeController.shared.changeTheme(to: theme)
            MockThemeController.shared.applyTheme()
            assertSnapshot(matching: value,
                           as: .image(precision: precision, size: size),
                           named: theme.rawValue,
                           file: file,
                           testName: localized ? "\(testName).\(Locale.current.description)" : testName,
                           line: line)
        }
    }

    private func enforceSnapshotDevice() {
        let is2XDevice = UIScreen.main.scale == 2
        let isVersion14 = operatingSystemVersion.majorVersion == 14

        guard is2XDevice, isVersion14 else {
            fatalError("Running device should have @2x screen scale and iOS13.")
        }
    }
}
