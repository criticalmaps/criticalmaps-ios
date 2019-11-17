//
//  NetworkStatusObserver.swift
//  CriticalMaps
//
//  Created by Илья Глущук on 12.11.2019.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

public enum NetworkStatus {
    case satisfied, none
}

public protocol NetworkObserver {
    var status: NetworkStatus { get }
    var statusUpdateHandler: ((NetworkStatus) -> Void)? { get set }
}
