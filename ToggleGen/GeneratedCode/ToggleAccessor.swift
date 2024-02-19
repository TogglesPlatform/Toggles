//  ToggleAccessor.swift

// swiftlint:disable file_length

import Foundation
import Toggles

public class ToggleAccessor {
    
    private(set) var manager: ToggleManager
    
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

    public var booleanToggle2: Bool {
        get { manager.value(for: ToggleVariables.booleanToggle2).boolValue! }
        set { manager.set(.bool(newValue), for: ToggleVariables.booleanToggle2) }
    }

    public var integerToggle2: Int {
        get { manager.value(for: ToggleVariables.integerToggle2).intValue! }
        set { manager.set(.int(newValue), for: ToggleVariables.integerToggle2) }
    }

    public var numericToggle2: Double {
        get { manager.value(for: ToggleVariables.numericToggle2).numberValue! }
        set { manager.set(.number(newValue), for: ToggleVariables.numericToggle2) }
    }

    public var stringToggle2: String {
        get { manager.value(for: ToggleVariables.stringToggle2).stringValue! }
        set { manager.set(.string(newValue), for: ToggleVariables.stringToggle2) }
    }

    public var objectToggle: Object {
        get { manager.value(for: ToggleVariables.objectToggle).objectValue! }
        set { manager.set(.object(newValue), for: ToggleVariables.objectToggle) }
    }

}

// swiftlint:enable file_length
