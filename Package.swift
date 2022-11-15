// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "package-datetime",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DateTime",
            targets: ["DateTime"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "0.4.2"))
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

        // Benchmark targets
        .executableTarget(
            name: "Clocks",
            dependencies: [
                .product(name: "BenchmarkSupport", package: "package-benchmark"),
                "DateTime"
            ],
            path: "Benchmarks/Clocks"
        )
    ]
)
