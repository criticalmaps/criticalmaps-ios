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

    private let networkLayer: NetworkLayer

    var updateTweetsCallback: (([Tweet]) -> Void)?

    init(networkLayer: NetworkLayer, url: URL) {
        self.networkLayer = networkLayer
        self.url = url
    }

    public func loadTweets(_ completion: ResultCallback<[Tweet]>? = nil) {
        let getTweetsRequest = TwitterRequest()
        networkLayer.get(request: getTweetsRequest) { [weak self] result in
            guard let self = self else { return }
            onMain {
                switch result {
                case let .failure(error):
                    completion?(.failure(error))
                    ErrorHandler.default.handleError(error)
                case let .success(response):
                    self.cachedTweets = response.statuses
                    completion?(.success(response.statuses))
                }
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
