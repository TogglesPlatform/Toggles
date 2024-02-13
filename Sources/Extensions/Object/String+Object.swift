//  String+Object.swift

import Foundation

extension String {
    var asObject: Object? {
        guard let data = self.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Object.self, from: data)
    }
}
