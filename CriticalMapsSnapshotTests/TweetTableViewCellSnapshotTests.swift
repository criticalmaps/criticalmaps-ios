//
//  TweetTableViewCellSnapshotTests.swift
//  CriticalMapsSnapshotTests
//
//  Created by MAXIM TSVETKOV on 04.10.19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

@testable import CriticalMaps
import XCTest

class TweetTableViewCellSnapshotTests: XCTestCase {
    private let tableViewController = UITableViewController()
    private let size = CGSize(width: 320, height: 100)
    // use constant date in the past
    private let tweetDate = Date(timeIntervalSince1970: 1530230956)
    private let CellReuseIdentifier = "Cell"
    
    override func setUp() {
        tableViewController.tableView.register(TweetTableViewCell.nib, forCellReuseIdentifier: CellReuseIdentifier)
        // use constant date in the past
        FormatDisplay.currentDate = Date(timeIntervalSince1970: 1530240956)
    }

    func testTweetTableViewCell() {
        // given
        let tweet = Tweet(text: "Hello World",
                          created_at: tweetDate,
                          user: TwitterUser(name: "Bar",
                                            screen_name: "Foo",
                                            profile_image_url_https: "haa"))
        let cell = tableViewController.tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier) as! TweetTableViewCell
        
        // when
        cell.setup(for: tweet)
        
        // then
        assertViewSnapshot(matching: cell, with: size)
    }
}
