//
// Created for CriticalMaps in 2020

import Foundation

struct ImageUploadRequest: APIRequestDefining {
    typealias ResponseDataType = String
    var endpoint: Endpoint = .gallery
    var headers: HTTPHeaders?
    var httpMethod: HTTPMethod = .post

    let base64Image: String?

    func makeRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = endpoint.baseUrl
        if let path = endpoint.path {
            components.path = path
        }
        if let queryItem = queryItem {
            components.queryItems = try URLQueryItem.encode(encodable: queryItem)
        }
        guard let url = components.url else {
            throw APIRequestBuildError.invalidURL
        }
        var request = URLRequest(url: url)

        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue

        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"image\""
        body += "\r\n\r\n\(base64Image ?? "")\r\n"
        body += "--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)
        request.httpBody = postData

        return request
    }
}
