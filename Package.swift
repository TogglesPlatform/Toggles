// swift-tools-version: 5.6
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
        
    ],
    targets: [
        .target(
            name: "Toggles",
            dependencies: [],
            path: "Sources",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "TogglesTests",
            dependencies: ["Toggles"],
            path: "Tests",
            resources: [.process("Resources")]
        )
    ]
)
