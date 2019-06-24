//
//  TwitterManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 1/28/19.
//

import Foundation

class TwitterManager {
    private let url: URL
    private var cachedTweets: [Tweet] = []

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()

    private let networkLayer: NetworkLayer

    init(networkLayer: NetworkLayer, url: URL) {
        self.networkLayer = networkLayer
        self.url = url
    }

    public func loadTweets(_ result: @escaping ResultCallback<[Tweet]>) {
        networkLayer.get(with: url, decodable: TwitterApiResponse.self, customDateFormatter: dateFormatter) { [weak self] response in
            DispatchQueue.main.async {
                guard let response = response else {
                    result(.failure(ApiError.couldFetchData))
                    return
                }
                self?.cachedTweets = response.statuses
                result(.success(response.statuses))
            }
        }
    }
}
