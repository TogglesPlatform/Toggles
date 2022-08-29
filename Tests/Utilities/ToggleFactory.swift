//  ToggleFactory.swift

@testable import Toggles

class ToggleFactory {
    
    let booleanToggle = Toggle(variable: "boolean_toggle",
                               value: .bool(true),
                               metadata: Metadata(description: "Boolean toggle", group: "group_1"))
    let integerToggle = Toggle(variable: "integer_toggle",
                               value: .int(42),
                               metadata: Metadata(description: "Integer toggle", group: "group_1"))
    let numericalToggle = Toggle(variable: "numerical_toggle",
                                 value: .number(3.1416),
                                 metadata: Metadata(description: "Numerical toggle", group: "group_2"))
    let stringToggle = Toggle(variable: "string_toggle",
                              value: .string("Hello World"),
                              metadata: Metadata(description: "String toggle", group: "group_2"))
    
    func makeToggles() -> [Toggle] {
        [
            booleanToggle,
            integerToggle,
            numericalToggle,
            stringToggle
        ]
    }
    
    func makeToggles(count: Int) -> [Toggle] {
        (0..<count).map { i in
            let metadata = Metadata(description: "description \(i)", group: "group \(i)")
            return Toggle(variable: "variable_\(i)", value: .int(i), metadata: metadata)
        }
    }
}
