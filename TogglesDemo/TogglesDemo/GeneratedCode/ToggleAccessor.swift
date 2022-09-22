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

    public var enableFeature: Bool {
        get { manager.value(for: Constant.enableFeature).boolValue! }
        set { manager.set(.bool(newValue), for: Constant.enableFeature) }
    }

    public var retryCount: Int {
        get { manager.value(for: Constant.retryCount).intValue! }
        set { manager.set(.int(newValue), for: Constant.retryCount) }
    }

    public var piValue: Double {
        get { manager.value(for: Constant.piValue).numberValue! }
        set { manager.set(.number(newValue), for: Constant.piValue) }
    }

    public var greetingMessage: String {
        get { manager.value(for: Constant.greetingMessage).stringValue! }
        set { manager.set(.string(newValue), for: Constant.greetingMessage) }
    }

    public var apiKey: String {
        get { manager.value(for: Constant.apiKey).secureValue! }
        set { manager.set(.secure(newValue), for: Constant.apiKey) }
    }

}

