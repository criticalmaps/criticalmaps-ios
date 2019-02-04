//
//  TwitterManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

class TwitterManager {
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

    init(networkLayer: NetworkLayer, url: URL) {
        self.networkLayer = networkLayer
        self.url = url
    }

    public func loadTweets(completion: (() -> Void)? = nil) {
        networkLayer.get(with: url, decodable: TwitterApiResponse.self, customDateFormatter: dateFormatter) { [weak self] response in
            DispatchQueue.main.async {
                defer {
                    completion?()
                }
                guard let response = response else {
                    return
                }
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
