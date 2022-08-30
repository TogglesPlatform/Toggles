import XCTest
@testable import Toggles

final class ModelsTests: XCTestCase {
    
    private let factory = ToggleFactory()
    
    func test_contract() throws {
        let url = Bundle.toggles.url(forResource: "contract", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let dataSourceFromFile = try JSONDecoder().decode(DataSource.self, from: data)
        let targetDataSource = DataSource(toggles: factory.makeToggles())
        XCTAssertEqual(dataSourceFromFile, targetDataSource)
    }
    
    func test_toggleBoolAccessor() throws {
        XCTAssertEqual(factory.booleanToggle.value.boolValue, true)
        XCTAssertNil(factory.integerToggle.value.boolValue)
        XCTAssertNil(factory.numericalToggle.value.boolValue)
        XCTAssertNil(factory.stringToggle.value.boolValue)
    }
    
    func test_toggleIntAccessor() throws {
        XCTAssertNil(factory.booleanToggle.value.intValue)
        XCTAssertEqual(factory.integerToggle.value.intValue, 42)
        XCTAssertNil(factory.numericalToggle.value.intValue)
        XCTAssertNil(factory.stringToggle.value.intValue)
    }
    
    func test_toggleDoubleAccessor() throws {
        XCTAssertNil(factory.booleanToggle.value.doubleValue)
        XCTAssertNil(factory.integerToggle.value.doubleValue)
        XCTAssertEqual(factory.numericalToggle.value.doubleValue, 3.1416)
        XCTAssertNil(factory.stringToggle.value.doubleValue)
    }
    
    func test_toggleStringAccessor() throws {
        XCTAssertNil(factory.booleanToggle.value.stringValue)
        XCTAssertNil(factory.integerToggle.value.stringValue)
        XCTAssertNil(factory.numericalToggle.value.stringValue)
        XCTAssertEqual(factory.stringToggle.value.stringValue, "Hello World")
    }
    
    func test_measureToggleCreation() throws {
        measure {
            _ = DataSource(toggles: factory.makeToggles(count: 100000))
        }
    }
    
    func test_measureToggleEncoding() throws {
        let dataSource = DataSource(toggles: factory.makeToggles(count: 100000))
        measure {
            _ = try! JSONEncoder().encode(dataSource)
        }
    }
    
    func test_measureToggleDecoding() throws {
        let dataSource = DataSource(toggles: factory.makeToggles(count: 100000))
        let data = try! JSONEncoder().encode(dataSource)
        measure {
            _ = try! JSONDecoder().decode(DataSource.self, from: data)
        }
    }
}
