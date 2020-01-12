//
//  CriticalMaps
import Foundation

extension JSONDecoder {
    static func decoder(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
}
