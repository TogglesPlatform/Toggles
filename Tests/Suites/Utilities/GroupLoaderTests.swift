//  GroupLoaderTests.swift

import XCTest
@testable import Toggles

final class GroupLoaderTests: XCTestCase {

    func test_loading() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let groups = try GroupLoader.loadGroups(datasourceUrl: url)
        let expectedGroups = [
            Group(title: "group_1", toggles: [
                Toggle(variable: "boolean_toggle", value: .bool(true), metadata: Metadata(description: "Boolean toggle", group: "group_1")),
                Toggle(variable: "integer_toggle", value: .int(42), metadata: Metadata(description: "Integer toggle", group: "group_1"))
            ]),
            Group(title: "group_2", toggles: [
                Toggle(variable: "numeric_toggle", value: .number(3.1416), metadata: Metadata(description: "Numeric toggle", group: "group_2")),
                Toggle(variable: "string_toggle", value: .string("Hello World"), metadata: Metadata(description: "String toggle", group: "group_2"))
            ]),
            Group(title: "group_3", toggles: [
                Toggle(variable: "secure_toggle", value: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"), metadata: Metadata(description: "Secure toggle", group: "group_3"))
            ])
        ]
        XCTAssertEqual(groups, expectedGroups)
    }
}
