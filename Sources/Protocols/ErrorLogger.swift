//  ErrorLogging.swift

import Foundation

public protocol ErrorLogger {
    func logError(_ error: ToggleManager.ProviderValueError)
}
