//  ToggleValue.swift

import Foundation

enum ToggleValue: Equatable, Encodable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)
    case secure(String)
}
