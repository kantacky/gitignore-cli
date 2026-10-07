// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "gitignore",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "gitignore",
            targets: ["GitIgnoreCLI"]
        )
    ],
    targets: [
        .executableTarget(name: "GitIgnoreCLI")
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
