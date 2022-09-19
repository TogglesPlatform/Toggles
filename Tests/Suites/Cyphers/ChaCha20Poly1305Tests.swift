//  ChaCha20Poly1305Tests.swift

import XCTest
@testable import Toggles

final class ChaCha20Poly1305Tests: XCTestCase {
    
    var cypher: ChaCha20Poly1305!
    let value = "some secret value"
    
    override func setUp() {
        super.setUp()
        cypher = ChaCha20Poly1305(key: "")
    }
    
    override func tearDown() {
        cypher = nil
        super.tearDown()
    }
    
    func test_encryptAndDecrypt() throws {
        let encryptedValue = try cypher.encrypt(value)
        let decryptedValue = try cypher.decrypt(encryptedValue)
        XCTAssertEqual(decryptedValue, value)
    }
}
