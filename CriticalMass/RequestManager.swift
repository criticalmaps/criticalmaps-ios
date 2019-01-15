//
//  RequestManager.swift
//  CriticalMapsWatch Extension
//
//  Created by Leonard Thomas on 12/17/18.
//

import Foundation

class RequestManager {
    
    let kRequestRepeatTime: TimeInterval = 12.0
    let kBaseURL = URL(string: "https://api.criticalmaps.net/")!
    
    let session: URLSession
    var lastResponse: ApiResponse? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("positionOthersChanged"), object: lastResponse)
        }
    }
    private var hasActiveRequest = false

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        session = URLSession(configuration: configuration)
        configureTimer()
    }
    
    private func configureTimer() {
        Timer.scheduledTimer(timeInterval: kRequestRepeatTime, target: self, selector: #selector(timerDidUpdate(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func timerDidUpdate(timer: Timer) {
        guard !hasActiveRequest else { return }
        loadData { (response) in
            if let response = response {
                self.lastResponse = response
            }
        }
    }

    func loadData(completion: @escaping (ApiResponse?) -> Void) {
        self.hasActiveRequest = true
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
