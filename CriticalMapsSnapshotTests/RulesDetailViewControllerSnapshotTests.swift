//
//  RulesDetailViewControllerSnapshotTests.swift
//  CriticalMapsSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class RulesDetailViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        let viewController = RulesDetailViewController(rule: Rule.cork)
        let navigationController = UINavigationController(rootViewController: viewController)

        // Then
        assertViewSnapshot(matching: navigationController.view)
    }
}
