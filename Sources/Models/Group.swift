//  Group.swift

import Foundation

struct Group: Equatable {
    let title: String
    let toggles: [Toggle]
    
    static func < (lhs: Group, rhs: Group) -> Bool {
        lhs.title < rhs.title
    }
}
