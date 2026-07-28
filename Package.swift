// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "docuseal-kit",
    platforms: [.macOS(.v15)],
    products: [
        .library(
            name: "DocuSealKit",
            targets: ["DocuSealKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.36.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.2.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.4"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.100.0"),
    ],
    targets: [
        .target(
            name: "DocuSealKit",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
            ]
        ),
        .testTarget(
            name: "DocuSealKitTests",
            dependencies: [
                "DocuSealKit"
            ]
        ),
    ]
)
