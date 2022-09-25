//  SearchFilterTests.swift

import XCTest
@testable import Toggles

final class SearchFilterTests: XCTestCase {
    
    func test_emptySearchText() throws {
        let groups = makeGroups(count: 100)
        let searchFilter = SearchFilter(groups: groups)
        measure {
            XCTAssertEqual(searchFilter.searchResults(for: ""), groups)
        }
    }
    
    func test_filterByGroup() throws {
        let groups = makeGroups(count: 100)
        let searchFilter = SearchFilter(groups: groups)
        let searchText = "Group 0"
        let results = searchFilter.searchResults(for: searchText)
        let allToggles = results.reduce([]) { $0 + $1.toggles }
        XCTAssertEqual(allToggles.count, 20)
        for result in results {
            XCTAssert(result.title.contains(searchText))
            for toggle in result.toggles {
                XCTAssert(toggle.metadata.group.contains(searchText))
            }
        }
    }
    
    func test_filterByDescription() throws {
        let groups = makeGroups(count: 100)
        let searchFilter = SearchFilter(groups: groups)
        let searchText = "Description 1"
        let results = searchFilter.searchResults(for: searchText)
        let allToggles = results.reduce([]) { $0 + $1.toggles }
        XCTAssertEqual(allToggles.count, 11)
        for result in results {
            for toggle in result.toggles {
                XCTAssert(toggle.metadata.description.contains(searchText))
            }
        }
    }
    
    func test_filterByVariable() throws {
        let groups = makeGroups(count: 100)
        let searchFilter = SearchFilter(groups: groups)
        let searchText = "Bool"
        let results = searchFilter.searchResults(for: searchText)
        let allToggles = results.reduce([]) { $0 + $1.toggles }
        XCTAssertEqual(allToggles.count, 20)
        for result in results {
            for toggle in result.toggles {
                XCTAssert(toggle.variable.contains(searchText))
            }
        }
    }
    
    // Note: Performance Test Baselines not available for Swift Packages
    // https://forums.swift.org/t/performance-test-baselines-not-available-for-swift-packages/45621
    
    func test_performanceEmptySearchText() throws {
        let groups = makeGroups(count: 100)
        let searchFilter = SearchFilter(groups: groups)
        measure {
            XCTAssertEqual(searchFilter.searchResults(for: ""), groups)
        }
    }
    
    func test_performanceFilterByGroup() throws {
        let groups = makeGroups(count: 100000)
        let searchFilter = SearchFilter(groups: groups)
        measure {
            _ = searchFilter.searchResults(for: "Group")
        }
    }
    
    func test_performanceFilterByDescription() throws {
        let groups = makeGroups(count: 100000)
        let searchFilter = SearchFilter(groups: groups)
        measure {
            _ = searchFilter.searchResults(for: "Description 1")
        }
    }
    
    func test_performanceFilterByVariable() throws {
        let groups = makeGroups(count: 100000)
        let searchFilter = SearchFilter(groups: groups)
        measure {
            _ = searchFilter.searchResults(for: "String")
        }
    }
    
    private func makeGroups(count: Int) -> [Group] {
        Dictionary(grouping: ToggleFactory().makeToggles(count: count), by: \.metadata.group)
            .map { Group(title: $0, toggles: $1.sorted(by: <)) }
            .sorted(by: <)
    }
}
