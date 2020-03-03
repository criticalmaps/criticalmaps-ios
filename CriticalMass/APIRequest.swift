import Foundation

enum APIRequestBuildError: Error {
    case invalidURL
}

public protocol APIRequestDefining {
    // String is just a default implementation and should be redefined if the Request uses query items
    associatedtype QueryDefiningDataType: Encodable = String
    associatedtype ResponseDataType: Decodable
    var endpoint: Endpoint { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItem: QueryDefiningDataType? { get }
    var requiresBackgroundTask: Bool { get }
    func makeRequest() throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

extension APIRequestDefining {
    var queryItem: QueryDefiningDataType? {
        nil
    }
}

extension APIRequestDefining {
    var requiresBackgroundTask: Bool {
        false
    }

    func makeRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = endpoint.baseUrl
        if let path = endpoint.path {
            components.path = path
        }
        if let queryItem = queryItem {
            components.queryItems = try URLQueryItem.encode(codable: queryItem)
        }
        guard let url = components.url else {
            throw APIRequestBuildError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addHeaders(headers)
        return request
    }

    func parseResponse(data: Data) throws -> ResponseDataType {
        try data.decoded()
    }
}

private extension URLRequest {
    mutating func addHeaders(_ httpHeaders: HTTPHeaders?) {
        guard let headers = httpHeaders else {
            return
        }
        for header in headers {
            addValue(header.key, forHTTPHeaderField: header.value)
        }
    }
}
