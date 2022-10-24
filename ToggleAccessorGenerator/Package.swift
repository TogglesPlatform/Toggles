// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToggleAccessorGenerator",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ToggleAccessorGenerator",
                    targets: ["ToggleAccessorGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/stencilproject/Stencil.git", exact: "0.15.1"),
    ],
    targets: [
        .executableTarget(
            name: "ToggleAccessorGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Stencil", package: "Stencil"),
            ],
            path: "Sources"),
        .testTarget(
            name: "ToggleAccessorGeneratorTests",
            dependencies: ["ToggleAccessorGenerator"],
            path: "Tests",
            resources: [.process("Resources")])
    ]
)
