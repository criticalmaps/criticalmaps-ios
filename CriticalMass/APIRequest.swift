import Foundation

public typealias HTTPHeaders = [String: String]

extension HTTPHeaders {
    static let contentTypeApplicationJSON: HTTPHeaders = ["application/json": "Content-Type"]
}

protocol APIRequestDefining {
    associatedtype ResponseDataType: Decodable
    var baseUrl: URL { get }
    var paths: [String] { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    func makeRequest() -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

extension APIRequestDefining {
    func makeRequest() -> URLRequest {
        var url = baseUrl
        paths.forEach { path in
            url.appendPathComponent(path)
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.addHeaders(headers)
        return request
    }

    func parseResponse(data: Data) throws -> ResponseDataType {
        return try data.decoded()
    }
}

extension URLRequest {
    mutating func addHeaders(_ httpHeaders: HTTPHeaders?) {
        guard let headers = httpHeaders else {
            return
        }
        for header in headers {
            addValue(header.key, forHTTPHeaderField: header.value)
        }
    }
}
