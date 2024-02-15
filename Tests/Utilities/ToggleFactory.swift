//  ToggleFactory.swift

@testable import Toggles

class ToggleFactory {
    
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
    
    func numericToggle(_ value: Double) -> Toggle {
        Toggle(variable: "numeric_toggle",
               value: .number(value),
               metadata: Metadata(description: "Numeric toggle", group: "group_2"))
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
    
    func objectToggle(_ value: Object) -> Toggle {
        Toggle(variable: "object_toggle",
               value: .object(value),
               metadata: Metadata(description: "Object toggle", group: "group_3"))
    }
    
    func booleanEmptyMetadataToggle(_ value: Bool) -> Toggle {
        Toggle(variable: "boolean_toggle",
               value: .bool(value),
               metadata: Metadata(description: "", group: ""))
    }
    
    func integerEmptyMetadataToggle(_ value: Int) -> Toggle {
        Toggle(variable: "integer_toggle",
               value: .int(value),
               metadata: Metadata(description: "", group: ""))
    }
    
    func numericEmptyMetadataToggle(_ value: Double) -> Toggle {
        Toggle(variable: "numeric_toggle",
               value: .number(value),
               metadata: Metadata(description: "", group: ""))
    }
    
    func stringEmptyMetadataToggle(_ value: String) -> Toggle {
        Toggle(variable: "string_toggle",
               value: .string(value),
               metadata: Metadata(description: "", group: ""))
    }
    
    func secureEmptyMetadataToggle(_ value: String) -> Toggle {
        Toggle(variable: "secure_toggle",
               value: .secure(value),
               metadata: Metadata(description: "", group: ""))
    }
    
    func objectEmptyMetadataToggle(_ value: Object) -> Toggle {
        Toggle(variable: "object_toggle",
               value: .object(value),
               metadata: Metadata(description: "", group: ""))
    }
    
    func makeToggles() -> [Toggle] {
        [
            booleanToggle(true),
            integerToggle(42),
            numericToggle(3.1416),
            stringToggle("Hello World"),
            secureToggle("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"),
            objectToggle(Object(map: [
                "boolProperty": .bool(true),
                "stringProperty": .string("value"),
                "intProperty": .int(421),
                "numberProperty": .number(12.3)])
            )
        ]
    }
    
    func makeTogglesWithNoMetadata() -> [Toggle] {
        [
            booleanEmptyMetadataToggle(true),
            integerEmptyMetadataToggle(42),
            numericEmptyMetadataToggle(3.1416),
            stringEmptyMetadataToggle("Hello World"),
            secureEmptyMetadataToggle("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"),
            objectEmptyMetadataToggle(Object(map: [
                "boolProperty": .bool(true),
                "stringProperty": .string("value"),
                "intProperty": .int(421),
                "numberProperty": .number(12.3)])
            )
        ]
    }
    
    func makeToggles(count: Int) -> [Toggle] {
        (0..<count).map { i in
            let modulo = i % 5
            let metadata = Metadata(description: "Description \(i)", group: "Group \(modulo)")
            switch modulo {
            case 0:
                return Toggle(variable: "\(Value.bool(false).typeDescription)_\(i)",
                              value: .bool(i%2 == 0),
                              metadata: metadata)
            case 1:
                return Toggle(variable: "\(Value.int(0).typeDescription)_\(i)",
                              value: .int(i),
                              metadata: metadata)
            case 2:
                return Toggle(variable: "\(Value.number(0.0).typeDescription)_\(i)",
                              value: .number(Double(i)),
                              metadata: metadata)
            case 3:
                return Toggle(variable: "\(Value.string("").typeDescription)_\(i)",
                              value: .string("\(i)"),
                              metadata: metadata)
            default:
                return Toggle(variable: "\(Value.secure("").typeDescription)_\(i)",
                              value: .secure("\(i)"),
                              metadata: metadata)
            }
        }
    }
}
