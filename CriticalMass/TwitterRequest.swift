import Foundation

struct TwitterRequest: APIRequestDefining {
    typealias ResponseDataType = TwitterApiResponse
    var baseUrl: URL
    var paths: [String]
    var httpMethod: HTTPMethod { return .get }
    var headers: HTTPHeaders?

    func parseResponse(data: Data) throws -> ResponseDataType {
        return try JSONDecoder.twitterDecoder.decode(ResponseDataType.self, from: data)
    }
}

extension DateFormatter {
    static let twitterDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
}

extension JSONDecoder {
    static let twitterDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.twitterDateFormatter)
        return decoder
    }()
}
