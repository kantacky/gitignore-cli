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
    ],
    swiftLanguageModes: [.v6],
)

for target in package.targets {
    target.swiftSettings = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("ImmutableWeakCaptures"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]
}
