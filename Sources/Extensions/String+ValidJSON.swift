//  String+ValidJSON.swift

import Foundation

extension String {
    var isValidJSON: Bool {
        guard let data = self.data(using: .utf8) else { return false }
        let object = try? JSONSerialization.jsonObject(with: data)
        return object != nil
    }
}

