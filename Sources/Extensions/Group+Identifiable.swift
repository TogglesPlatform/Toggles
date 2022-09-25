//  Group+Identifiable.swift

import Foundation

extension Group: Identifiable {
    public var id: String { title }
}
