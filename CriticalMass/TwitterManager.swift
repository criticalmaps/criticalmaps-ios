//
//  TwitterManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

@objc(PLTwitterManager)
class TwitterManager: NSObject {
    private let url: URL
    private var cachedTweets: [Tweet] = [] {
        didSet {
            updateTweetsCallback?(cachedTweets)
        }
    }

    private let networkLayer: NetworkLayer

    var updateTweetsCallback: (([Tweet]) -> Void)?

    init(networkLayer: NetworkLayer, url: URL = URL(string: "https://api.criticalmaps.net/twitter")!) {
        self.networkLayer = networkLayer
        self.url = url
        super.init()
    }

    public func loadTweets() {
        networkLayer.get(with: url, decodable: [Tweet].self) { [weak self] tweets in
            guard let tweets = tweets else {
                return
            }
            DispatchQueue.main.async {
                self?.cachedTweets = tweets
            }
        }
    }

    public func getTweets() -> [Tweet] {
        if cachedTweets.isEmpty {
            loadTweets()
        }
        return cachedTweets
    }
}
