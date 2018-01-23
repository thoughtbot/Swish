// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Swish",
  dependencies: [
    .package(url: "https://github.com/thoughtbot/Argo.git", from: "4.0.0"),
    .package(url: "https://github.com/thoughtbot/Runes.git", from: "4.0.0"),
    .package(url: "https://github.com/antitypical/Result", from: "3.1.0"),
  ],
  targets: [
    .target(
      name: "Swish",
      dependencies: ["Result"],
      path: "Source"
    ),
  ]
)
