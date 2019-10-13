//
//  WaitOperation.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 13/10/2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import UIKit

final class WaitOperation: AsyncOperation {
    private let interval: TimeInterval
    
    init(with interval: TimeInterval) {
        self.interval = interval
        super.init()
    }
    
    override func main() {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.completeOperation()
        }
    }
}
