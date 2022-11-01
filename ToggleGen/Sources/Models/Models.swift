//  Models.swift

import Foundation

struct Toggle: Equatable {

    typealias Variable = String

    struct ToggleMetadata: Equatable, Decodable {
        let propertyName: String?
    }

    enum Value: Equatable, Decodable {
        case bool(Bool)
        case int(Int)
        case number(Double)
        case string(String)
        case secure(String)
    }
    
    let variable: Variable
    let value: Value
    let metadata: ToggleMetadata?
}

struct Datasource: Equatable, Decodable {
    public let toggles: [Toggle]
}
