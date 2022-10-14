//  Toggle+ComparableTests.swift

import XCTest
@testable import JustTweakMigrator

final class Toggle_ComparableTests: XCTestCase {
    
    func test_toggleComparable_Variable() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var2",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_ValueBool() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(false),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_ValueInt() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .int(42),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .int(108),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_ValueNumber() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .number(3.1416),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .number(3.15),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_ValueString() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .string("ABC"),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .string("BCD"),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_ValueSecure() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .secure("ABC"),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .secure("BCD"),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_MetadataDescription() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc2", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_MetadataGroup() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group2", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_MetadataPropertyNameSomeSome() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property2"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_MetadataPropertyNameSomeNone() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: nil))
        XCTAssertFalse(toggle1 < toggle2)
    }
    
    func test_toggleComparable_MetadataPropertyNameNoneSome() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: nil))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: "property1"))
        XCTAssertTrue(toggle1 < toggle2)
    }
    
    func test_toggleComparable_MetadataPropertyNameNoneNone() throws {
        let toggle1 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: nil))
        let toggle2 = Toggle(variable: "var1",
                             value: .bool(true),
                             metadata: ToggleMetadata(description: "desc1", group: "group1", propertyName: nil))
        XCTAssertFalse(toggle1 < toggle2)
    }
}
