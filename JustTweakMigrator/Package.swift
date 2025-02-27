// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JustTweakMigrator",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "JustTweakMigrator", targets: ["JustTweakMigrator"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.5.0"))
    ],
    targets: [
        .executableTarget(
            name: "JustTweakMigrator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources",
            swiftSettings: [
                .enableUpcomingFeature("InternalImportsByDefault"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        ),
        .testTarget(
            name: "JustTweakMigratorTests",
            dependencies: ["JustTweakMigrator"],
            path: "Tests",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("InternalImportsByDefault"),
                .enableUpcomingFeature("ExistentialAny")
            ]
        )
    ]
)
