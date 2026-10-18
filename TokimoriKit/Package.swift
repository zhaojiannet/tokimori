// swift-tools-version: 6.4
import PackageDescription

let concurrency: [SwiftSetting] = [.enableUpcomingFeature("ApproachableConcurrency")]

let package = Package(
  name: "TokimoriKit",
  platforms: [.macOS(.v14)],
  products: [
    .library(name: "TokimoriCore", targets: ["TokimoriCore"]),
    .library(name: "TokimoriPlatform", targets: ["TokimoriPlatform"]),
  ],
  targets: [
    .target(name: "TokimoriPlatform", swiftSettings: concurrency),
    .target(name: "TokimoriCore", dependencies: ["TokimoriPlatform"], swiftSettings: concurrency),
    .testTarget(
      name: "TokimoriCoreTests", dependencies: ["TokimoriCore", "TokimoriPlatform"],
      swiftSettings: concurrency),
  ]
)
