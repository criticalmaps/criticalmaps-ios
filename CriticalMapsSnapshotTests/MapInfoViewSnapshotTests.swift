//
//  MapInfoViewSnapshotTests.swift
//  CriticalMapsSnapshotTests
//
//  Created by Leonard Thomas on 17.12.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class MapInfoViewSnapshotTests: XCTestCase {
    private let size = CGSize(width: 320, height: 100)

    func testInfoStyle() {
        // given
        let configuration = MapInfoView.Configuration(title: "Info Message", style: .info)
        let view = MapInfoView.fromNib()

        // when
        view.configure(with: configuration)

        // then
        assertViewSnapshot(matching: view, with: size)
    }

    func testAlertStyle() {
        // given
        let configuration = MapInfoView.Configuration(title: "Critical Maps isn't updating. Please check back later.", style: .alert)
        let view = MapInfoView.fromNib()

        // when
        view.configure(with: configuration)

        // then
        assertViewSnapshot(matching: view, with: size)
    }
}
