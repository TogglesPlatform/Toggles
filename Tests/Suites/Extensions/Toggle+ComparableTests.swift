//  Toggle+ComparableTests.swift

import XCTest
@testable import Toggles

final class Toggle_ComparableTests: XCTestCase {
    
    func test_comparable() throws {
        let toggle1 = Toggle(variable: "variable_1", value: .int(1), metadata: Metadata(description: "", group: ""))
        let toggle2 = Toggle(variable: "variable_2", value: .int(1), metadata: Metadata(description: "", group: ""))
        XCTAssertTrue(toggle1 == toggle1)
        XCTAssertFalse(toggle1 == toggle2)
        XCTAssertTrue(toggle1 < toggle2)
        XCTAssertFalse(toggle1 > toggle2)
    }
}
