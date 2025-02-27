//  Logger.swift

import Foundation

public protocol Logger {
    func log(_ error: ToggleError)
}

public enum ToggleError: Error {
    case invalidValueType(Variable, Value, any ValueProvider)
    case insecureValue(Variable, any ValueProvider)
}
