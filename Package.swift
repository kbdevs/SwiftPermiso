// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SwiftPermiso",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "SwiftPermiso", targets: ["SwiftPermiso"]),
    ],
    targets: [
        .target(name: "SwiftPermiso"),
        .testTarget(name: "SwiftPermisoTests", dependencies: ["SwiftPermiso"]),
    ]
)
