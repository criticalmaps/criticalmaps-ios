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

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()

    private let networkLayer: NetworkLayer

    var updateTweetsCallback: (([Tweet]) -> Void)?

    init(networkLayer: NetworkLayer, url: URL = URL(string: "https://api.criticalmaps.net/twitter")!) {
        self.networkLayer = networkLayer
        self.url = url
        super.init()
    }

    public func loadTweets() {
        networkLayer.get(with: url, decodable: TwitterApiResponse.self, customDateFormatter: dateFormatter) { [weak self] response in
            guard let response = response else {
                return
            }
            DispatchQueue.main.async {
                self?.cachedTweets = response.statuses
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

extension TwitterManager {
    // workaround for now to create TwitterManager from Objc
    @objc class func objcInit() -> TwitterManager {
        return TwitterManager(networkLayer: NetworkOperator())
    }
}
