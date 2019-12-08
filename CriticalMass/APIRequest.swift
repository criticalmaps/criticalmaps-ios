import Foundation

public protocol APIRequestDefining {
    associatedtype ResponseDataType: Decodable
    var endpoint: Endpoint { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var requiresBackgroundTask: Bool { get }
    func makeRequest() -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

extension APIRequestDefining {
    var requiresBackgroundTask: Bool {
        false
    }

    func makeRequest() -> URLRequest {
        var request = URLRequest(url: endpoint.url)
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
