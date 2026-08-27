// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PixelMarquee",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PixelMarquee",
            targets: ["PixelMarquee"]
        ),
    ],
    targets: [
        .target(
            name: "PixelMarquee",
            dependencies: [],
            path: "Sources/PixelMarquee"
        ),
        .testTarget(
            name: "PixelMarqueeTests",
            dependencies: ["PixelMarquee"],
            path: "Tests/PixelMarqueeTests"
        ),
    ]
)
