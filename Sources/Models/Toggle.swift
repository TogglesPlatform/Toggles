//  Toggle.swift

import Foundation

/// Model representing a toggle.
/// Toggles represent feature/configuration flags. At their core, they are a key-value pairs where the key, due to the context, is called variable.
/// Metadata information is used by ``TogglesView`` for the purpose of visualization.
public struct Toggle: Equatable {
    public let variable: Variable
    public let value: Value
    public let metadata: Metadata
}
