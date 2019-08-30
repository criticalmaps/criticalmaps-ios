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
            updateContentStateCallback?(.results(cachedTweets))
        }
    }

    private var contentState: ContentState<[Tweet]> = .loading(.cmLoadingController) {
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
                    completion?(.failure(error))
                    ErrorHandler.default.handleError(error)
                case let .success(response):
                    self.cachedTweets = response.statuses
                    completion?(.success(response.statuses))
                }
            }
        }
    }

    public func getTweets() {
        contentState = .loading(.cmLoadingController)
        loadTweets()
    }
}
