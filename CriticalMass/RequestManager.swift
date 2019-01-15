//
//  RequestManager.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

class RequestManager {
    private let kRequestRepeatTime: TimeInterval = 12.0
    private let kBaseURL = URL(string: "https://api.criticalmaps.net/")!

    private let session: URLSession

    private var hasActiveRequest = false
    private var dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: configuration)
        configureTimer()
    }

    private func configureTimer() {
        Timer.scheduledTimer(timeInterval: kRequestRepeatTime, target: self, selector: #selector(timerDidUpdate(timer:)), userInfo: nil, repeats: true)
    }

    @objc private func timerDidUpdate(timer _: Timer) {
        guard !hasActiveRequest else { return }
        updateData { response in
            if let response = response {
                self.dataStore.update(with: response)
            }
        }
    }

    private func updateData(completion: @escaping (ApiResponse?) -> Void) {
        hasActiveRequest = true
        let url = kBaseURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, _, _ in
            defer {
                self.hasActiveRequest = false
            }
            if let data = data {
                let decodedResponse = try? JSONDecoder().decode(ApiResponse.self, from: data)
                completion(decodedResponse)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
