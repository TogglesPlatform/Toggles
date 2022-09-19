//  Toggle+IdentifiableTests.swift

import XCTest
@testable import Toggles

final class Toggle_IdentifiableTests: XCTestCase {
    
    func test_id() throws {
        let variable = "someIdentifyingValue"
        let toggle = Toggle(variable: variable, value: .none, metadata: Metadata(description: "", group: ""))
        XCTAssertEqual(toggle.id, variable)
    }
}
