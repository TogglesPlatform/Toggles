//  GroupLoader.swift

import Foundation

struct GroupLoader {
    
    static func loadGroups(datasourceUrl: URL) throws -> [Group] {
        let content = try Data(contentsOf: datasourceUrl)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        return Dictionary(grouping: datasource.toggles, by: \.metadata.group)
            .map { Group(title: $0, toggles: $1.sorted(by: <)) }
            .sorted(by: <)
    }
}
