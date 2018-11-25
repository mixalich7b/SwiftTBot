// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftTBot",
    products: [
        .library(name: "SwiftTBot", targets: ["SwiftTBot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", from: "3.4.1")
    ],
    targets: [
        .target(name: "SwiftTBot", dependencies: ["ObjectMapper"]),
    ]
)
