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
        get { manager.value(for: Constants.booleanToggle).boolValue! }
        set { manager.set(.bool(newValue), for: Constants.booleanToggle) }
    }

    public var integerToggle: Int {
        get { manager.value(for: Constants.integerToggle).intValue! }
        set { manager.set(.int(newValue), for: Constants.integerToggle) }
    }

    public var numericalToggle: Double {
        get { manager.value(for: Constants.numericalToggle).numberValue! }
        set { manager.set(.number(newValue), for: Constants.numericalToggle) }
    }

    public var stringToggle: String {
        get { manager.value(for: Constants.stringToggle).stringValue! }
        set { manager.set(.string(newValue), for: Constants.stringToggle) }
    }

    public var encryptedToggle: String {
        get { manager.value(for: Constants.encryptedToggle).secureValue! }
        set { manager.set(.secure(newValue), for: Constants.encryptedToggle) }
    }

    public var userDefinedBooleanToggle: Bool {
        get { manager.value(for: Constants.booleanToggle2).boolValue! }
        set { manager.set(.bool(newValue), for: Constants.booleanToggle2) }
    }

    public var userDefinedIntegerToggle: Int {
        get { manager.value(for: Constants.integerToggle2).intValue! }
        set { manager.set(.int(newValue), for: Constants.integerToggle2) }
    }

    public var userDefinedNumericalToggle: Double {
        get { manager.value(for: Constants.numericalToggle2).numberValue! }
        set { manager.set(.number(newValue), for: Constants.numericalToggle2) }
    }

    public var userDefinedStringToggle: String {
        get { manager.value(for: Constants.stringToggle2).stringValue! }
        set { manager.set(.string(newValue), for: Constants.stringToggle2) }
    }

}
