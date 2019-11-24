//
//  NetworkActivityIndicatorHelper.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/5/19.
//

#if canImport(UIKit)
    import UIKit
#endif

class NetworkActivityIndicatorHelper {
    private var requestCounter = 0 {
        didSet {
            onMain {
                #if canImport(UIKit)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = self.requestCounter > 0
                #endif
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
