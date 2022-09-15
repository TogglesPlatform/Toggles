//  ToggleObservable.swift

import Combine
import Foundation

public class ToggleObservable: ObservableObject {
    
    var manager: ToggleManager
    var cancellables: Set<AnyCancellable> = []
    
    @Published
    public var value: Value = .none
    
    @Published
    public var boolValue: Bool = false
    
    @Published
    public var intValue: Int = 0
    
    @Published
    public var numberValue: Double = 0.0
    
    @Published
    public var stringValue: String = ""
    
    @Published
    public var secureValue: String = ""
    
    public init(manager: ToggleManager, variable: Variable) {
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
                case .secure(let value):
                    self.secureValue = value
                }
            }
            .store(in: &cancellables)
    }
}
