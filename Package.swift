// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "Swish",
  products: [
    .library(
      name: "Swish",
      targets: ["Swish"]
    ),
    .library(
      name: "Swoosh",
      targets: ["Swoosh"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.0")),
  ],
  targets: [
    .target(
      name: "Swish",
      dependencies: []
    ),
    .target(
      name: "Swoosh",
      dependencies: ["Swish"]
    ),
    .testTarget(
      name: "SwishTests",
      dependencies: ["Swish", "Swoosh", "Quick", "Nimble"]
    ),
  ]
)
