// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftlyRest",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v12),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftlyRest",
            targets: ["SwiftlyRest"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift", .upToNextMajor(from: "24.0.0")),
        .package(url: "https://github.com/PedroCavaleiro/ExtendedSwift", .upToNextMajor(from: "1.2.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftlyRest",
            dependencies: [
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "ExtendedSwift", package: "ExtendedSwift")
            ]
        ),
    ]
)
