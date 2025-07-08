// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeedrunKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        // Main library
        .library(
            name: "SpeedrunKit",
            targets: ["SpeedrunKit"]),
        // CLI tool for testing
        .executable(
            name: "speedrun-cli",
            targets: ["SpeedrunCLI"])
    ],
    dependencies: [
        // DocC plugin for documentation
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        // Main library target
        .target(
            name: "SpeedrunKit",
            dependencies: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]),
        // CLI tool target
        .executableTarget(
            name: "SpeedrunCLI",
            dependencies: ["SpeedrunKit"],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]),
        // Test target
        .testTarget(
            name: "SpeedrunKitTests",
            dependencies: ["SpeedrunKit"]),
    ]
)
