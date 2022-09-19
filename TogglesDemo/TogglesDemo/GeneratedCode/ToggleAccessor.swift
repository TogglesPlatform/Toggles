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
        get { manager.value(for: Constant.booleanToggle).boolValue! }
        set { manager.set(.bool(newValue), for: Constant.booleanToggle) }
    }

    public var integerToggle: Int {
        get { manager.value(for: Constant.integerToggle).intValue! }
        set { manager.set(.int(newValue), for: Constant.integerToggle) }
    }

    public var numericalToggle: Double {
        get { manager.value(for: Constant.numericalToggle).numberValue! }
        set { manager.set(.number(newValue), for: Constant.numericalToggle) }
    }

    public var stringToggle: String {
        get { manager.value(for: Constant.stringToggle).stringValue! }
        set { manager.set(.string(newValue), for: Constant.stringToggle) }
    }

    public var encryptedToggle: String {
        get { manager.value(for: Constant.encryptedToggle).secureValue! }
        set { manager.set(.secure(newValue), for: Constant.encryptedToggle) }
    }

    public var booleanToggle2: Bool {
        get { manager.value(for: Constant.booleanToggle2).boolValue! }
        set { manager.set(.bool(newValue), for: Constant.booleanToggle2) }
    }

    public var integerToggle2: Int {
        get { manager.value(for: Constant.integerToggle2).intValue! }
        set { manager.set(.int(newValue), for: Constant.integerToggle2) }
    }

    public var numericalToggle2: Double {
        get { manager.value(for: Constant.numericalToggle2).numberValue! }
        set { manager.set(.number(newValue), for: Constant.numericalToggle2) }
    }

    public var stringToggle2: String {
        get { manager.value(for: Constant.stringToggle2).stringValue! }
        set { manager.set(.string(newValue), for: Constant.stringToggle2) }
    }

}

