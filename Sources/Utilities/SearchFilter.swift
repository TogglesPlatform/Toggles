//  SearchFilter.swift

import Foundation

class SearchFilter {
    
    private let groups: [Group]
    
    init(groups: [Group]) {
        self.groups = groups
    }
    
    func searchResults(for searchText: String) -> [Group] {
        guard !searchText.isEmpty else { return groups }
        return groups.map { group in
            let toggles = group.toggles.filter { group in
                let searchValue = searchText.lowercased()
                let searchMatchesGroup = {
                    group.metadata.group.lowercased().contains(searchValue)
                }
                let searchMatchesDescription = {
                    group.metadata.description.lowercased().contains(searchValue)
                }
                let searchMatchesVariable = {
                    group.variable.lowercased().contains(searchValue)
                }
                return searchMatchesGroup() || searchMatchesDescription() || searchMatchesVariable()
            }
            return Group(title: group.title, toggles: toggles)
        }
        .filter { !$0.toggles.isEmpty }
    }
}
