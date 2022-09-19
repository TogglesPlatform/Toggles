//  ToggleFactory.swift

@testable import Toggles

class ToggleFactory {
    
    func noneToggle() -> Toggle {
        Toggle(variable: "boolean_toggle",
               value: .none,
               metadata: Metadata(description: "Boolean toggle", group: "group_1"))
    }
    
    func booleanToggle(_ value: Bool) -> Toggle {
        Toggle(variable: "boolean_toggle",
               value: .bool(value),
               metadata: Metadata(description: "Boolean toggle", group: "group_1"))
    }
    
    func integerToggle(_ value: Int) -> Toggle {
        Toggle(variable: "integer_toggle",
               value: .int(value),
               metadata: Metadata(description: "Integer toggle", group: "group_1"))
    }
    
    func numericalToggle(_ value: Double) -> Toggle {
        Toggle(variable: "numerical_toggle",
               value: .number(value),
               metadata: Metadata(description: "Numerical toggle", group: "group_2"))
    }
    
    func stringToggle(_ value: String) -> Toggle {
        Toggle(variable: "string_toggle",
               value: .string(value),
               metadata: Metadata(description: "String toggle", group: "group_2"))
    }
    
    func secureToggle(_ value: String) -> Toggle {
        Toggle(variable: "secure_toggle",
               value: .secure(value),
               metadata: Metadata(description: "Secure toggle", group: "group_3"))
    }
    
    func makeToggles() -> [Toggle] {
        [
            // noneToggle
            booleanToggle(true),
            integerToggle(42),
            numericalToggle(3.1416),
            stringToggle("Hello World"),
            secureToggle("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK")
        ]
    }
    
    func makeToggles(count: Int) -> [Toggle] {
        (0..<count).map { i in
            let metadata = Metadata(description: "description \(i)", group: "group \(i)")
            return Toggle(variable: "variable_\(i)", value: .int(i), metadata: metadata)
        }
    }
}
