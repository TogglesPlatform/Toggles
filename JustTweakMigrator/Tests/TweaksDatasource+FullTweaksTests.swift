//  TweaksDatasource+FullTweaksTests.swift

import XCTest
@testable import JustTweakMigrator

final class TweaksDatasource_FullTweaksTests: XCTestCase {
    
    func test_fullTweaks() throws {
        let tweaksDatasource = TweaksDatasourceFactory.makeTestTweaksDatasource()
        let fullTweaks = tweaksDatasource.fullTweaks
        let expectedFullTweaks = [
            FullTweak(title: "Var 1",
                      group: "group_1",
                      value: true,
                      encrypted: false,
                      generatedPropertyName: "var1",
                      variable: "variable_1",
                      feature: "feature_1"),
            FullTweak(title: "Var 2",
                      group: "group_1",
                      value: 42,
                      encrypted: false,
                      generatedPropertyName: "var2",
                      variable: "variable_2",
                      feature: "feature_1"),
            FullTweak(title: "Var 3",
                      group: "group_2",
                      value: 3.1416,
                      encrypted: false,
                      generatedPropertyName: "var3",
                      variable: "variable_3",
                      feature: "feature_1"),
            FullTweak(title: "Var 4",
                      group: "group_2",
                      value: "Hello World",
                      encrypted: false,
                      generatedPropertyName: "var4",
                      variable: "variable_4",
                      feature: "feature_2"),
            FullTweak(title: "Var 5",
                      group: "group_2",
                      value: "__encrypted_value__",
                      encrypted: true,
                      generatedPropertyName: "var5",
                      variable: "variable_5",
                      feature: "feature_2")
        ]
        XCTAssertEqual(fullTweaks, expectedFullTweaks)
    }
}
