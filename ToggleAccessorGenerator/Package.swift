// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToogleAccessorGenerator",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "toogleaccessorgenerator",
                    targets: ["ToogleAccessorGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/stencilproject/Stencil.git", exact: "0.15.1"),
    ],
    targets: [
        .executableTarget(
            name: "ToogleAccessorGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Stencil", package: "Stencil"),
            ],
            path: "Sources"),
        .testTarget(
            name: "ToogleAccessorGeneratorTests",
            dependencies: ["ToogleAccessorGenerator"],
            path: "Tests",
            resources: [.process("Resources")])
    ]
)
