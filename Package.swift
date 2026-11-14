// swift-tools-version: 5.9
import PackageDescription

// Released package — the compiled core is fetched by SPM from a pinned,
// checksummed remote zip (built by kibo CI, core v2.16.5).
let package = Package(
    name: "K9OKibo",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [.library(name: "K9OKibo", targets: ["K9OKibo"])],
    targets: [
        .binaryTarget(
            name: "kibo_kms_rest_ffiFFI",
            url: "https://k9o.dev/sdk-kibo-swift/1.5.0/kibo_kms_rest_ffiFFI.xcframework.zip",
            checksum: "23eb3ceedf8f906c01ffe4f7432e000cb862c96f353e169f0c84f68026635bbd"
        ),
        .target(
            name: "K9OKibo",
            dependencies: ["kibo_kms_rest_ffiFFI"],
            path: "Sources/K9OKibo"
        ),
        .testTarget(
            name: "K9OKiboTests",
            dependencies: ["K9OKibo"],
            path: "Tests/K9OKiboTests"
        ),
    ]
)
