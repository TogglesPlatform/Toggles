//  CipherConfiguration+Defaults.swift

import Foundation
import Toggles

extension CipherConfiguration {
    
    static let chaChaPoly: CipherConfiguration = {
        CipherConfiguration(algorithm: .chaCha20Poly1305, key: "AyUcYw-qWebYF-z0nWZ4")
    }()
    
    static let chaChaPolyWithIgnoreEmptyStrings: CipherConfiguration = {
        CipherConfiguration(algorithm: .chaCha20Poly1305, key: "AyUcYw-qWebYF-z0nWZ4", ignoreEmptyStrings: true)
    }()
}
