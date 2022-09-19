// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ToggleCypher",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
//        .executable(name: "toogleencryptor",
//                    targets: ["ToogleEncryptor"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "ToggleCypher",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources"),
        .testTarget(
            name: "ToggleCypherTests",
            dependencies: ["ToggleCypher"],
            path: "Tests")
    ]
)
