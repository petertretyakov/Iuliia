// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Iuliia",
    products: [
        .library(name: "Iuliia", targets: ["Iuliia"]),
    ],
    targets: [
        .target(
            name: "Iuliia",
            dependencies: [],
            resources: [ .process("Resources/Schemas") ]
        ),
        .testTarget(name: "IuliiaTests", dependencies: ["Iuliia"])
    ]
)
