//  ToggleManager+Trace.swift

import Foundation

extension ToggleManager {

    typealias ProviderName = String
    
    struct Trace: Equatable, Identifiable {
        var id: String { providerName }
        let providerName: ProviderName
        let value: Value
    }

    func stackTrace(for variable: Variable) -> [Trace] {
        queue.sync {
            var trace: [Trace] = []
            
            if let mutableValueProvider = mutableValueProvider {
                let value = mutableValueProvider.value(for: variable)
                trace.append(Trace(providerName: mutableValueProvider.name, value: value))
            }
            
            trace += valueProviders.map { provider -> Trace in
                let value = provider.value(for: variable)
                return Trace(providerName: provider.name, value: value)
            }
            
            let value = defaultValueProvider.value(for: variable)
            trace.append(Trace(providerName: defaultValueProvider.name, value: value))
            
            return trace
        }
    }
}
