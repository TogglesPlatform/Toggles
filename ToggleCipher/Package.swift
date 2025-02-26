// swift-tools-version: 6.0
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
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.5.0"))
    ],
    targets: [
        .executableTarget(
            name: "ToggleCipher",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources",
            swiftSettings: [
                .enableExperimentalFeature("InternalImportsByDefault"),
                .enableExperimentalFeature("ExistentialAny")
            ]
        ),
        .testTarget(
            name: "ToggleCipherTests",
            dependencies: ["ToggleCipher"],
            path: "Tests",
            swiftSettings: [
                .enableExperimentalFeature("InternalImportsByDefault"),
                .enableExperimentalFeature("ExistentialAny")
            ]
        )
    ]
)
