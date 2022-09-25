//  Group+IdentifiableTests.swift

import XCTest
@testable import Toggles

final class Group_IdentifiableTests: XCTestCase {
    
    func test_id() throws {
        let title = "someIdentifyingValue"
        let group = Group(title: title, toggles: [])
        XCTAssertEqual(group.id, title)
    }
}
