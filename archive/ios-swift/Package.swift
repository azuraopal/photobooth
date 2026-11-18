// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "photobooth",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "photobooth",
            targets: ["photobooth"]
        )
    ],
    targets: [
        .executableTarget(
            name: "photobooth",
            path: "."
        )
    ]
)
