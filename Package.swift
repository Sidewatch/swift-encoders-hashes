// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EncodersHashes",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "EncodersHashes", targets: ["EncodersHashes"]),
    ],
    targets: [
        .target(name: "EncodersHashes", path: "Sources"),
        .testTarget(name: "EncodersHashesTests", dependencies: ["EncodersHashes"], path: "Tests"),
    ]
)
