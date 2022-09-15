//  Models.swift

import Foundation

struct Toggle: Equatable {

    typealias Variable = String

    enum Value: Equatable, Decodable {
        case bool(Bool)
        case int(Int)
        case number(Double)
        case string(String)
        case secure(String)
    }
    
    struct Metadata: Equatable, Decodable {
        let propertyName: String?
    }
    
    let variable: Variable
    let value: Value
    let metadata: Metadata
}

struct Datasource: Equatable, Decodable {
    public let toggles: [Toggle]
}
