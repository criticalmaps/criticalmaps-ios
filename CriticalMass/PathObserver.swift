//
//  PathObserver.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 12.11.2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Network

@available(iOS 12.0, *)
final class PathObserver: NetworkObserver {
    var status: NetworkStatus {
        monitor.currentPath.status == .satisfied ? .satisfied : .none
    }

    var statusUpdateHandler: ((NetworkStatus) -> Void)?

    private let monitor: NWPathMonitor = NWPathMonitor()

    init() {
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
