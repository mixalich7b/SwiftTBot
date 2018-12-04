// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "EchoBotLinuxExample",
    products: [
        .executable(name: "EchoBotLinuxExample", targets: ["EchoBotLinuxExample"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/mixalich7b/SwiftTBot.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "EchoBotLinuxExample",
            dependencies: ["SwiftTBot"]),
        .testTarget(
            name: "EchoBotLinuxExampleTests",
            dependencies: ["EchoBotLinuxExample"]),
    ]
)
