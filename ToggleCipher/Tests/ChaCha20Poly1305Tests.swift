//  ChaCha20Poly1305Tests.swift

import XCTest
@testable import ToggleCipher

final class ChaCha20Poly1305Tests: XCTestCase {
    
    var cipher: ChaCha20Poly1305!
    let value = "some secret value"
    
    override func setUp() {
        super.setUp()
        cipher = ChaCha20Poly1305(key: "")
    }
    
    override func tearDown() {
        cipher = nil
        super.tearDown()
    }
    
    func test_encryptAndDecrypt() throws {
        let encryptedValue = try cipher.encrypt(value)
        let decryptedValue = try cipher.decrypt(encryptedValue)
        XCTAssertEqual(decryptedValue, value)
    }
}
