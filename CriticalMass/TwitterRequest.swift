import Foundation

struct TwitterRequest: APIRequestDefining {
    typealias ResponseDataType = TwitterApiResponse
    var endpoint: Endpoint = .twitter
    var headers: HTTPHeaders?
    var httpMethod: HTTPMethod = .get

    func parseResponse(data: Data) throws -> ResponseDataType {
        try data.decoded(decoder: .init(dateDecodingStrategy: .formatted(.twitterDateFormatter)))
    }
}

private extension DateFormatter {
    static let twitterDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return formatter
    }()
}
