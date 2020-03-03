import Foundation

struct TwitterRequest: APIRequestDefining {
    typealias ResponseDataType = TwitterApiResponse
    var endpoint: Endpoint = .twitter
    var headers: HTTPHeaders?
    var httpMethod: HTTPMethod = .get

    func parseResponse(data: Data) throws -> ResponseDataType {
        let decoder = JSONDecoder.decoder(dateDecodingStrategy: .formatted(.twitterDateFormatter))
        return try decoder.decode(ResponseDataType.self, from: data)
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
