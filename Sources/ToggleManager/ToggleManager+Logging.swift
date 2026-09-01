//  ToggleManager+Logging.swift

import Foundation

extension ToggleManager {

    func log(_ message: @autoclosure () -> String) {
        if verbose { print("[ToggleManager] \(message())") }
    }
}
