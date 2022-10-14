//  TweaksDatasource+DecodableTests.swift

import XCTest
@testable import JustTweakMigrator

final class TweaksDatasource_DecodableTests: XCTestCase {

    func test_tweakDecoding() throws {
        let tweaksDatasourceUrl = Bundle.module.url(forResource: "TestTweaks", withExtension: "json")!
        let data = try Data(contentsOf: tweaksDatasourceUrl)
        let tweaksDatasource = try JSONDecoder().decode(TweaksDatasource.self, from: data)
        XCTAssertEqual(tweaksDatasource.tweaks.keys.count, 2)
        let uiCustomizationTweaks = tweaksDatasource.tweaks["ui_customization"]!
        XCTAssertEqual(uiCustomizationTweaks.count, 5)
        let generalTweaks = tweaksDatasource.tweaks["general"]!
        XCTAssertEqual(generalTweaks.count, 4)
    }
}
