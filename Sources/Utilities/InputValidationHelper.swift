//  InputValidationHelper.swift

import UIKit

struct InputValidationHelper {
    
    let toggle: Toggle
    
    func isInputValid(_ input: String) -> Bool {
        guard !input.isEmpty else { return true }
        switch toggle.value {
        case .bool:
            return input.boolValue != nil
        case .int:
            return Int(input) != nil
        case .number:
            return Double(input) != nil
        case .string:
            return true
        case .secure:
            return true
        }
    }
    
    func overridingValue(for input: String) -> Value {
        switch toggle.value {
        case .bool:
            return .bool(input.boolValue ?? false)
        case .int:
            return .int(Int(input) ?? 0)
        case .number:
            return .number(Double(input) ?? 0.0)
        case .string:
            return .string(input)
        case .secure:
            return .secure(input)
        }
    }
    
#if os(iOS)
    var keyboardType: UIKeyboardType {
        switch toggle.value {
        case .bool:
            return .default
        case .int:
            return .numberPad
        case .number:
            return .decimalPad
        case .string:
            return .default
        case .secure:
            return .default
        }
    }
#endif
    
    var isBooleanToggle: Bool {
        if case .bool = toggle.value {
            return true
        }
        return false
    }
    
    var toggleNeedsValidation: Bool {
        if case .bool = toggle.value { return false }
        if case .string = toggle.value { return false }
        if case .secure = toggle.value { return false }
        return true
    }
}
