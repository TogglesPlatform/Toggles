//  CypherConfiguration+Defaults.swift

import Foundation
import Toggles

extension CypherConfiguration {
    
    static let chaChaPoly: CypherConfiguration = {
        CypherConfiguration(algorithm: .chaCha20Poly1305, key: "AyUcYw-qWebYF-z0nWZ4")
    }()
}
