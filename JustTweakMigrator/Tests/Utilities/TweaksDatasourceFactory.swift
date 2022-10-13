//  TweaksDatasourceFactory.swift

import Foundation
@testable import JustTweakMigrator

class TweaksDatasourceFactory {
    
    static func makeTestTweaksDatasource() -> TweaksDatasource {
        let tweaks: [TweakFeature : [TweakVariable : Tweak]] = [
            "feature_1": [
                "variable_1": Tweak(title: "Var 1",
                                    description: "This is var 1",
                                    group: "group_1",
                                    value: true,
                                    encrypted: false,
                                    generatedPropertyName: "var1"),
                "variable_2": Tweak(title: "Var 2",
                                    description: "This is var 2",
                                    group: "group_1",
                                    value: 42,
                                    encrypted: false,
                                    generatedPropertyName: "var2"),
                "variable_3": Tweak(title: "Var 3",
                                    description: "This is var 3",
                                    group: "group_2",
                                    value: 3.1416,
                                    encrypted: false,
                                    generatedPropertyName: "var3"),
            ],
            "feature_2": [
                "variable_4": Tweak(title: "Var 4",
                                    description: "This is var 4",
                                    group: "group_2",
                                    value: "Hello World",
                                    encrypted: false,
                                    generatedPropertyName: "var4"),
                "variable_5": Tweak(title: "Var 5",
                                    description: "This is var 5",
                                    group: "group_2",
                                    value: "__encrypted_value__",
                                    encrypted: true,
                                    generatedPropertyName: "var5")
            ]
        ]
        return TweaksDatasource(tweaks: tweaks)
    }
    
    static func makeTestTweaksDatasourceWithDuplicate() -> TweaksDatasource {
        let tweaks: [TweakFeature : [TweakVariable : Tweak]] = [
            "feature_1": [
                "variable_1": Tweak(title: "Var 1",
                                    description: "This is var 1",
                                    group: "group_1",
                                    value: true,
                                    encrypted: false,
                                    generatedPropertyName: "var1"),
                "variable_2": Tweak(title: "Var 2",
                                    description: "This is var 2",
                                    group: "group_1",
                                    value: 42,
                                    encrypted: false,
                                    generatedPropertyName: "var2"),
                "variable_3": Tweak(title: "Var 3",
                                    description: "This is var 3",
                                    group: "group_2",
                                    value: 3.1416,
                                    encrypted: false,
                                    generatedPropertyName: "var3"),
            ],
            "feature_2": [
                "variable_3": Tweak(title: "Var 3",
                                    description: "This is var 3",
                                    group: "group_2",
                                    value: 3.1416,
                                    encrypted: false,
                                    generatedPropertyName: "var3"),
                "variable_4": Tweak(title: "Var 4",
                                    description: "This is var 4",
                                    group: "group_2",
                                    value: "Hello World",
                                    encrypted: false,
                                    generatedPropertyName: "var4"),
                "variable_5": Tweak(title: "Var 5",
                                    description: "This is var 5",
                                    group: "group_2",
                                    value: "Hello World",
                                    encrypted: true,
                                    generatedPropertyName: "var5")
            ]
        ]
        return TweaksDatasource(tweaks: tweaks)
    }
    
    static func makeTestTweaksDatasourceWithInvalidValue() -> TweaksDatasource {
        let tweaks: [TweakFeature : [TweakVariable : Tweak]] = [
            "feature_1": [
                "variable_1": Tweak(title: "Var 1",
                                    description: "This is var 1",
                                    group: "group_1",
                                    value: true,
                                    encrypted: false,
                                    generatedPropertyName: "var1"),
                "variable_2": Tweak(title: "Var 2",
                                    description: "This is var 2",
                                    group: "group_1",
                                    value: 42,
                                    encrypted: false,
                                    generatedPropertyName: "var2"),
                "variable_3": Tweak(title: "Var 3",
                                    description: "This is var 3",
                                    group: "group_2",
                                    value: ["invalid"],
                                    encrypted: false,
                                    generatedPropertyName: "var3"),
            ],
            "feature_2": [
                "variable_4": Tweak(title: "Var 4",
                                    description: "This is var 4",
                                    group: "group_2",
                                    value: "Hello World",
                                    encrypted: false,
                                    generatedPropertyName: "var4"),
                "variable_5": Tweak(title: "Var 5",
                                    description: "This is var 5",
                                    group: "group_2",
                                    value: "Hello World",
                                    encrypted: true,
                                    generatedPropertyName: "var5")
            ]
        ]
        return TweaksDatasource(tweaks: tweaks)
    }
}
