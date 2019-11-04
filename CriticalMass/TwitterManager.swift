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
            contentState = .results(cachedTweets)
        }
    }

    private var contentState: ContentState<[Tweet]> = .loading(.default) {
        didSet {
            updateContentStateCallback?(contentState)
        }
    }

    private let networkLayer: NetworkLayer

    var updateContentStateCallback: ((ContentState<[Tweet]>) -> Void)?

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
                    ErrorHandler.default.handleError(error)
                    self.contentState = .error(.default)
                    completion?(.failure(error))
                case let .success(response):
                    self.cachedTweets = response.statuses
                    completion?(.success(response.statuses))
                }
            }
        }
    }

    public func getTweets() {
        contentState = .loading(.default)
        loadTweets()
    }
}
