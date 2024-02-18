//  ToggleObservable.swift

import Combine
import Foundation

/// `ObservableObject` tied to a toggle that publishes updates whenever its value changes.
public class ToggleObservable: ObservableObject {
    
    var manager: ToggleManager
    var cancellables: Set<AnyCancellable> = []
    
    /// The value of the toggle.
    @Published
    public var value: Value
    
    /// The raw value of the toggle if it's of boolean type, nil otherwise.
    @Published
    public var boolValue: Bool?
    
    /// The raw value of the toggle if it's of integer type, nil otherwise.
    @Published
    public var intValue: Int?
    
    /// The raw value of the toggle if it's of number type, nil otherwise.
    @Published
    public var numberValue: Double?
    
    /// The raw value of the toggle if it's of string type, nil otherwise.
    @Published
    public var stringValue: String?
    
    /// The raw value of the toggle if it's of secure type, nil otherwise.
    @Published
    public var secureValue: String?
    
    /// The raw value of the toggle if it's of object type, nil otherwise.
    @Published
    public var objectValue: Object?
    
    /// The default intializer.
    ///
    /// - Parameters:
    ///   - manager: The manager used to publish changes to the toggle.
    ///   - variable: The variable of the toggle to observe changes for.
    public init(manager: ToggleManager, variable: Variable) {
        self.manager = manager
        value = .bool(false)
        subscribe(on: variable)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    private func subscribe(on variable: Variable) {
        manager.publisher(for: variable)
            .sink { [weak self] value in
                guard let self else { return }
                self.value = value
                switch value {
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
                case .object(let value):
                    self.objectValue = value
                }
            }
            .store(in: &cancellables)
    }
}
