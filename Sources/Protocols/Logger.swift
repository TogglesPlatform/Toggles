//  Logger.swift

import Foundation

public protocol Logger {
    func log(_ error: ToggleError)
}

public enum ToggleError: Error {
    case invalidValueType(Variable, Value, ValueProvider)
    case insecureValue(Variable, ValueProvider)
}
