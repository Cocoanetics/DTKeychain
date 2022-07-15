// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "DTKeychain",
    platforms: [
        .iOS(.v9),         //.v8 - .v13
        .macOS(.v10_10),    //.v10_10 - .v10_15
        .tvOS(.v9),        //.v9 - .v13
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DTKeychain",
            targets: ["DTKeychain"]),
    ],
    targets: [
        .target(
            name: "DTKeychain",
            dependencies: [],
            path: "Core",
            exclude: ["Framework-Info.plist", "DTKeychain-Prefix.pch"],
            cSettings: [
                .headerSearchPath("include/DTKeychain"),
                .define("BITCODE_GENERATION_MODE", to: "bitcode"),
                .define("ENABLE_BITCODE", to: "YES")
            ]
        ),
        .testTarget(
            name: "DTKeychainTests",
            dependencies: ["DTKeychain"],
            path: "Test",
            exclude: ["Info.plist"],
            resources: [],
            cSettings: [
                .headerSearchPath("include"),
            ]
        )
    ]
)
