import XCTest
@testable import Toggles

final class ModelsTests: XCTestCase {
    
    private let factory = ToggleFactory()
    
    func test_contract() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let datasourceFromFile = try JSONDecoder().decode(Datasource.self, from: data)
        let targetDatasource = Datasource(toggles: factory.makeToggles())
        XCTAssertEqual(datasourceFromFile, targetDatasource)
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
            _ = Datasource(toggles: factory.makeToggles(count: 10000))
        }
    }
    
    func test_measureToggleEncoding() throws {
        let datasource = Datasource(toggles: factory.makeToggles(count: 10000))
        measure {
            _ = try! JSONEncoder().encode(datasource)
        }
    }
    
    func test_measureToggleDecoding() throws {
        let datasource = Datasource(toggles: factory.makeToggles(count: 10000))
        let data = try! JSONEncoder().encode(datasource)
        measure {
            _ = try! JSONDecoder().decode(Datasource.self, from: data)
        }
    }
}
