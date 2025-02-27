//  TweaksDatasource+Codable.swift

import Foundation

extension TweaksDatasource: Decodable {
    
    enum CodingError: Error {
        case missingValue
    }
    
    init(from decoder: any Decoder) throws {
        let values = try decoder.singleValueContainer()
        tweaks = try values.decode([TweakFeature: [TweakVariable: Tweak]].self)
    }
}
