// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BorderBeam",
    platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v1)],
    products: [
        .library(name: "BorderBeam", targets: ["BorderBeam"]),
        .library(name: "BorderBeamDemo", targets: ["BorderBeamDemo"]),
    ],
    targets: [
        .target(
            name: "BorderBeam",
            path: "Sources/BorderBeam",
            resources: [.process("Shaders")]   // compiles BorderBeam.metal into the bundle's metallib
        ),
        .target(
            name: "BorderBeamDemo",
            dependencies: ["BorderBeam"],
            path: "Sources/BorderBeamDemo"
        ),
    ]
)
