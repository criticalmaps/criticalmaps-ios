//
//  URLCodable.swift
//  CriticalMaps
//
//  Created by Leonard Thomas on 5/7/19.
//  Copyright © 2019 Pokus Labs. All rights reserved.
//

import Foundation

enum URLCodableError: Error {
    case encodingFailed
    case unsupportedDataType
    case decodingFailed
}

protocol URLCodable {
    associatedtype T: Codable
    var scheme: String? { get }
    var host: String? { get }
    var path: String { get }
    var queryObject: T { get }

    init(scheme: String?, host: String?, path: String, queryObject: T) throws
}

extension URLCodable {
    func asURL() throws -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = try URLQueryItem.encode(encodable: queryObject)
        guard let result = urlComponents.url?.absoluteString else {
            throw URLCodableError.encodingFailed
        }
        return result
    }

    static func decode(from urlString: String) throws -> Self {
        guard let urlComponents = URLComponents(string: urlString) else {
            throw URLCodableError.decodingFailed
        }

        let codableObject = try decode(type: T.self, from: urlComponents.queryItems ?? [])
        return try self.init(scheme: urlComponents.scheme, host: urlComponents.host, path: urlComponents.path, queryObject: codableObject)
    }

    private static func decode<T: Codable>(type: T.Type, from items: [URLQueryItem]) throws -> T {
        let dict = items.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        return try data.decoded()
    }
}

extension URLQueryItem {
    static func encode(encodable: Encodable) throws -> [URLQueryItem] {
        let jsonData = try encodable.encoded()
        guard let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            throw URLCodableError.encodingFailed
        }
        return try dict.lazy.map { (key, value) -> URLQueryItem in
            switch value {
            case let stringValue as String:
                return URLQueryItem(name: key, value: stringValue)
            case let stringConvertible as CustomStringConvertible:
                return URLQueryItem(name: key, value: String(describing: stringConvertible))
            default:
                // More types are currently not supported and should be added if needed
                throw URLCodableError.encodingFailed
            }
        }.sorted { a, b in
            // The sorting is only required to make testing easier
            a.name > b.name
        }
    }
}
