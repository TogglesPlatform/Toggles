//  ToggleManager+Caching.swift

import Foundation

extension ToggleManager {
    
    func getCachedValue(for variable: Variable) -> Value? {
        queue.sync {
            cache[variable]
        }
    }
}
