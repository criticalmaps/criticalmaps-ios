//
//  NetworkActivityIndicatorHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/5/19.
//

import Foundation

class NetworkActivityIndicatorHelper {
    private var requestCounter = 0 {
        didSet {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.requestCounter > 0
            }
        }
    }

    public func didStartRequest() {
        requestCounter += 1
    }

    public func didEndRequest() {
        requestCounter -= 1
    }
}
