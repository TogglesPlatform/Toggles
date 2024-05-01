// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToggleCipher",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ToggleCipher", targets: ["ToggleCipher"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "ToggleCipher",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources",
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
                        ]),
        .testTarget(
            name: "ToggleCipherTests",
            dependencies: ["ToggleCipher"],
            path: "Tests",
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
                        ])
    ]
)
