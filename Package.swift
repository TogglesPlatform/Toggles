// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Toggles",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v7),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "Toggles",
            targets: ["Toggles"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Toggles",
            dependencies: [],
            path: "Sources",
            resources: [.process("Resources")],
            swiftSettings: [
                .enableExperimentalFeature("ConciseMagicFile"),
                .enableExperimentalFeature("ForwardTrailingClosures"),
                .enableExperimentalFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("DeprecateApplicationMain"),
                .enableExperimentalFeature("ImportObjcForwardDeclarations"),
                .enableExperimentalFeature("DisableOutwardActorInference"),
                .enableExperimentalFeature("InternalImportsByDefault"),
                .enableExperimentalFeature("ExistentialAny"),
                .enableExperimentalFeature("ImplicitOpenExistentials"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "TogglesTests",
            dependencies: ["Toggles"],
            path: "Tests",
            resources: [.process("Resources")],
            swiftSettings: [
                .enableExperimentalFeature("ConciseMagicFile"),
                .enableExperimentalFeature("ForwardTrailingClosures"),
                .enableExperimentalFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("DeprecateApplicationMain"),
                .enableExperimentalFeature("ImportObjcForwardDeclarations"),
                .enableExperimentalFeature("DisableOutwardActorInference"),
                .enableExperimentalFeature("InternalImportsByDefault"),
                .enableExperimentalFeature("ExistentialAny"),
                .enableExperimentalFeature("ImplicitOpenExistentials"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
)
