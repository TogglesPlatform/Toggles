//  ToggleManager+Trace.swift

import Foundation

typealias ProviderName = String
typealias Trace = (ProviderName, Value?)

extension ToggleManager {
    
    func stackTrace(for variable: Variable) -> [Trace] {
        queue.sync {
            var trace: [Trace] = []
            
            if let mutableValueProvider = mutableValueProvider {
                let value = mutableValueProvider.optionalValue(for: variable)
                trace.append((mutableValueProvider.name, value))
            }
            
            trace += optionalValueProviders.map { provider -> Trace in
                let value = provider.optionalValue(for: variable)
                return (provider.name, value)
            }
            
            let value = valueProvider.value(for: variable)
            trace.append((valueProvider.name, value))
            
            return trace
        }
    }
}
