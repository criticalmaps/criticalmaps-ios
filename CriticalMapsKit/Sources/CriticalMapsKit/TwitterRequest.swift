import CriticalMapsFoundation
import Foundation

public struct TwitterRequest: APIRequestDefining {
    public typealias ResponseDataType = TwitterApiResponse
    public var endpoint: Endpoint = .twitter
    public var headers: HTTPHeaders?
    public var httpMethod: HTTPMethod = .get

    public func parseResponse(data: Data) throws -> ResponseDataType {
        try JSONDecoder.twitterDecoder.decode(ResponseDataType.self, from: data)
    }

    public init() {}
}

private extension DateFormatter {
    static let twitterDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
}

private extension JSONDecoder {
    static let twitterDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.twitterDateFormatter)
        return decoder
    }()
}
