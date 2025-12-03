// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BGTasks",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BGTasks",
            targets: ["BGTasks"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BGTasks",
            path: "BGTasks/Core",
            sources: ["Classes"],
            resources: [
                .process("Assets")
            ],
            swiftSettings: [
                .define("SPM_BUILD")
            ]
        ),
    ]
)
