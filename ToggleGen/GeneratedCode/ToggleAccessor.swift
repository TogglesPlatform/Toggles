//  ToggleAccessor.swift

import Foundation
import Toggles

public class ToggleAccessor {
    
    private let manager: ToggleManager
    
    public init(manager: ToggleManager) {
        self.manager = manager
    }
}

extension ToggleAccessor {

    public var booleanToggle: Bool {
        get { manager.value(for: ToggleVariables.booleanToggle).boolValue! }
        set { manager.set(.bool(newValue), for: ToggleVariables.booleanToggle) }
    }

    public var integerToggle: Int {
        get { manager.value(for: ToggleVariables.integerToggle).intValue! }
        set { manager.set(.int(newValue), for: ToggleVariables.integerToggle) }
    }

    public var numericToggle: Double {
        get { manager.value(for: ToggleVariables.numericToggle).numberValue! }
        set { manager.set(.number(newValue), for: ToggleVariables.numericToggle) }
    }

    public var stringToggle: String {
        get { manager.value(for: ToggleVariables.stringToggle).stringValue! }
        set { manager.set(.string(newValue), for: ToggleVariables.stringToggle) }
    }

    public var encryptedToggle: String {
        get { manager.value(for: ToggleVariables.encryptedToggle).secureValue! }
        set { manager.set(.secure(newValue), for: ToggleVariables.encryptedToggle) }
    }

    public var userDefinedBooleanToggle: Bool {
        get { manager.value(for: ToggleVariables.booleanToggle2).boolValue! }
        set { manager.set(.bool(newValue), for: ToggleVariables.booleanToggle2) }
    }

    public var userDefinedIntegerToggle: Int {
        get { manager.value(for: ToggleVariables.integerToggle2).intValue! }
        set { manager.set(.int(newValue), for: ToggleVariables.integerToggle2) }
    }

    public var userDefinedNumericToggle: Double {
        get { manager.value(for: ToggleVariables.numericToggle2).numberValue! }
        set { manager.set(.number(newValue), for: ToggleVariables.numericToggle2) }
    }

    public var userDefinedStringToggle: String {
        get { manager.value(for: ToggleVariables.stringToggle2).stringValue! }
        set { manager.set(.string(newValue), for: ToggleVariables.stringToggle2) }
    }

}
