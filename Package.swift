// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "SwiftTBot",
    products: [
        .library(name: "SwiftTBot", targets: ["SwiftTBot"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mixalich7b/ObjectMapper.git", from: "3.4.2")
    ],
    targets: [
        .target(name: "SwiftTBot", dependencies: ["ObjectMapper"]),
    ]
)
