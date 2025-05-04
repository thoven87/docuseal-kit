// swift-tools-version:6.0
import PackageDescription

let package = Package(
  name: "docuseal-kit",
  platforms: [.macOS(.v14)],
  products: [
    .library(
      name: "DocuSealKit",
      targets: ["DocuSealKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.25.2"),
    .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
  ],
  targets: [
    .target(
      name: "DocuSealKit",
      dependencies: [
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
        .product(name: "Logging", package: "swift-log"),
      ]),
    .testTarget(
      name: "DocuSealKitTests",
      dependencies: [
        "DocuSealKit"
      ]),
  ]
)
