//  Metadata.swift

import Foundation

/// Model containing metadata information for a toggle.
public struct Metadata: Equatable, Codable {
    public let description: String
    public let group: String
    public let propertyName: String?
    
    init(description: String, group: String, propertyName: String? = nil) {
        self.description = description
        self.group = group
        self.propertyName = propertyName
    }
}
