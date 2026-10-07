// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "gitignore",
    products: [
        .library(
            name: "GitIgnoreCLI",
            targets: ["GitIgnoreCLI"]
        )
    ],
    targets: [
        .target(name: "GitIgnoreCLI")
    ]
)
