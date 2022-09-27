//  ToggleManager+Logging.swift

import Foundation

extension ToggleManager {
    
    func log(_ message: String) {
        if verbose { print("[ToggleManager] \(message)") }
    }
}
