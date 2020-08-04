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

extension XCTestCase {
    func assertViewSnapshot(for themes: [Theme] = [.light, .dark],
                            matching value: UIView,
                            with size: CGSize? = nil,
                            precision: Float = 1,
                            file: StaticString = #file,
                            testName: String = #function,
                            line: UInt = #line)
    {
        themes.forEach { theme in
            MockThemeController.shared.changeTheme(to: theme)
            MockThemeController.shared.applyTheme()
            assertSnapshot(matching: value,
                           as: .image(precision: precision, size: size),
                           named: theme.displayName,
                           file: file,
                           testName: testName,
                           line: line)
        }
    }
}

private extension Theme {
    var displayName: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}
