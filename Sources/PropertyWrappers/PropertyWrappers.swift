//  PropertyWrappers.swift

import Foundation

public protocol RawType {}

extension Bool: RawType {}
extension Int: RawType {}
extension Double: RawType {}
extension String: RawType {}

@propertyWrapper
public struct ToggleProperty<T: RawType> {
    let variable: String
    let manager: ToggleManager

    public init(variable: String, manager: ToggleManager) {
        self.variable = variable
        self.manager = manager
    }

    public var wrappedValue: T {
        get {
            let value = manager.value(for: variable)
            if let boolValue = value.boolValue { return boolValue as! T }
            else if let intValue = value.intValue { return intValue as! T }
            else if let doubleValue = value.doubleValue { return doubleValue as! T }
            else if let stringValue = value.stringValue { return stringValue as! T }
            assertionFailure("Wrapped value is not a known raw type conforming to RawType")
            return false as! T
        }
        set {
            switch newValue {
            case is Bool:
                manager.set(.bool(newValue as! Bool), for: variable)
            case is Int:
                manager.set(.int(newValue as! Int), for: variable)
            case is Double:
                manager.set(.number(newValue as! Double), for: variable)
            case is String:
                manager.set(.string(newValue as! String), for: variable)
            default:
                assertionFailure("Wrapped value is not a known raw type conforming to RawType")
            }
        }
    }
}
