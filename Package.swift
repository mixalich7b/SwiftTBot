import PackageDescription

let package = Package(
    name: "SwiftTBot",
    dependencies: [
        .Package(url: "https://github.com/mixalich7b/ObjectMapper.git", Version("1.3.1")!)
    ],
    targets: [
        Target(name: "SwiftTBot/Classes")
    ],
    exclude: [
        "Examples",
        "SwiftTBot.podspec"
    ]
)
