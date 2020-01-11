// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DangerSwiftProse",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DangerSwiftProse",
            targets: ["DangerSwiftProse"]
        ),
        .library(name: "DangerDeps",
                 type: .dynamic,
                 targets: ["DangerSwiftProse"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "2.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "7.3.1"), // dev
        .package(url: "https://github.com/f-meloni/TestSpy", from: "0.3.1"), // dev
        .package(url: "https://github.com/shibapm/Komondor", from: "1.0.2"), // dev
        .package(url: "https://github.com/shibapm/PackageConfig", from: "0.10.0"), // dev
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.35.8"), // dev
        .package(url: "https://github.com/f-meloni/Rocket", from: "1.0.0"), // dev
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DangerSwiftProse",
            dependencies: ["Danger"]
        ),
        .testTarget(name: "DangerSwiftProseTests", dependencies: ["DangerSwiftProse", "Nimble", "TestSpy", "DangerFixtures"]), // dev
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-commit": [
                "swift run swiftformat .",
                "git add .",
            ],
        ],
        "rocket": [
            "after": [
                "push",
            ],
        ],
    ]).write()
#endif
