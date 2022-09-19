//  MockSingleValueProvider.swift

import Foundation
import Toggles

class MockSingleValueProvider: ValueProvider {
    
    var name: String = "SingleValue (mock)"
    
    private let value: Value
    
    init(value: Value) {
        self.value = value
    }
    
    func value(for variable: Variable) -> Value {
        value
    }
}
