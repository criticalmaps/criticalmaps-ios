//
//  AsyncOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 13/10/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _isFinished: Bool = false
    
    override var isFinished: Bool {
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
        
        get {
            return _isFinished
        }
    }

    private var _isExecuting: Bool = false
    
    override var isExecuting: Bool {
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
        
        get {
            return _isExecuting
        }
    }
    
    func completeOperation() {
        isExecuting = false
        isFinished = true
    }

    override func cancel() {
        super.cancel()
        completeOperation()
    }

    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        main()
    }
}
