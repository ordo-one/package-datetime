// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "package-datetime",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "DateTime",
            targets: ["DateTime"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DateTime",
            dependencies: []
        ),
        .testTarget(
            name: "DateTimeTests",
            dependencies: ["DateTime"]
        ),
        .testTarget(
            name: "EpochDateTimeTests",
            dependencies: ["DateTime"]
        )
    ]
)
