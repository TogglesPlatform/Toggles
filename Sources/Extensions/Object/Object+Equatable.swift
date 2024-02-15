//  Object+Equatable.swift

import Foundation

extension Object: Equatable {
    public static func == (lhs: Object, rhs: Object) -> Bool {
        lhs.map == rhs.map
    }
}
