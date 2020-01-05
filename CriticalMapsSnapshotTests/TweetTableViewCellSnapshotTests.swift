//
//  TweetTableViewCellSnapshotTests.swift
//  CriticalMapsSnapshotTests
//
//  Created by MAXIM TSVETKOV on 04.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
@testable import CriticalMapsKit
import XCTest

class TweetTableViewCellSnapshotTests: XCTestCase {
    private let size = CGSize(width: 320, height: 100)
    // use constant date in the past
    private let tweetDate = Date(timeIntervalSince1970: 1_530_230_956)

    override func setUp() {
        // use constant date in the past
        FormatDisplay.currentDate = Date(timeIntervalSince1970: 1_530_240_956)
    }

    func testTweetTableViewCell() {
        // given
        let tweet = Tweet(text: "Hello World",
                          created_at: tweetDate,
                          user: TwitterUser(name: "Bar",
                                            screen_name: "Foo",
                                            profile_image_url_https: "haa"),
                          id_str: "test_id")
        let cell = TweetTableViewCell.fromNib()

        // when
        cell.setup(for: tweet)

        // then
        assertViewSnapshot(matching: cell, with: size)
    }
}
