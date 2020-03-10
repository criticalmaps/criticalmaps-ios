//
//  TwitterManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

class TwitterManager {
    private let request: TwitterRequest
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
    private let errorHandler: ErrorHandler

    var updateContentStateCallback: ((ContentState<[Tweet]>) -> Void)?

    init(networkLayer: NetworkLayer, request: TwitterRequest, errorHandler: ErrorHandler = PrintErrorHandler()) {
        self.networkLayer = networkLayer
        self.errorHandler = errorHandler
        self.request = request
    }

    public func loadTweets(_ completion: ResultCallback<[Tweet]>? = nil) {
        networkLayer.get(request: request) { [weak self] result in
            onMain {
                switch result {
                case let .failure(error):
                    self?.errorHandler.handleError(error)
                    self?.contentState = .error(.fallback)
                    completion?(.failure(error))
                case let .success(response):
                    self?.cachedTweets = response.statuses
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
