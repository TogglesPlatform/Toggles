//  ToggleObservable.swift

import Combine
import Foundation

public class ToggleObservable: ObservableObject {
    
    var manager: ToggleManager
    var cancellables: Set<AnyCancellable> = []
    
    @Published
    var value: Value = .none
    
    @Published
    var boolValue: Bool = false
    
    @Published
    var intValue: Int = 0
    
    @Published
    var numberValue: Double = 0.0
    
    @Published
    var stringValue: String = ""
    
    @Published
    var encryptedValue: String = ""
    
    init(manager: ToggleManager, variable: Variable) {
        self.manager = manager
        subscribe(on: variable)
    }
    
    private func subscribe(on variable: Variable) {
        manager.publisher(for: variable)
            .sink { value in
                self.value = value
                switch value {
                case .none:
                    break
                case .bool(let value):
                    self.boolValue = value
                case .int(let value):
                    self.intValue = value
                case .number(let value):
                    self.numberValue = value
                case .string(let value):
                    self.stringValue = value
                case .encrypted(let value):
                    self.encryptedValue = value
                }
            }
            .store(in: &cancellables)
    }
}
