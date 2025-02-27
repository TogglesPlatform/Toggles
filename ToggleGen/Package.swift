// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToggleGen",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ToggleGen",
                    targets: ["ToggleGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.5.0")),
        .package(url: "https://github.com/stencilproject/Stencil.git", exact: "0.15.1"),
    ],
    targets: [
        .executableTarget(
            name: "ToggleGen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Stencil", package: "Stencil"),
            ],
            path: "Sources",
            swiftSettings: [
                .enableUpcomingFeature("InternalImportsByDefault"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .testTarget(
            name: "ToggleGenTests",
            dependencies: ["ToggleGen"],
            path: "Tests",
            resources: [.process("Resources")],
            swiftSettings: [
                .enableUpcomingFeature("InternalImportsByDefault"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        )
    ]
)
