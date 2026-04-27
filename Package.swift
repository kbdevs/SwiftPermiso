// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "SwiftPermiso",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "SwiftPermiso", targets: ["SwiftPermiso"]),
        .executable(name: "SwiftPermisoPreview", targets: ["SwiftPermisoPreview"]),
    ],
    targets: [
        .target(name: "SwiftPermiso"),
        .executableTarget(name: "SwiftPermisoPreview", dependencies: ["SwiftPermiso"]),
        .testTarget(name: "SwiftPermisoTests", dependencies: ["SwiftPermiso"]),
    ]
)
