//  SingleValueMockProvider.swift

import Foundation
import Toggles

class SingleValueMockProvider: ValueProvider {
    
    var name: String = "Mock"
    
    private let value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    func value(for variable: Variable) -> Value {
        value
    }
}
