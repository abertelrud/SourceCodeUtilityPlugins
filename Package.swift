// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SourceCodeUtilityPlugins",
    products: [
        .plugin(
            name: "Reformat Source Code",
            targets: [
                "Reformat Source Code"
            ]
        ),
        .plugin(
            name: "Regenerate Contributors List",
            targets: [
                "Regenerate Contributors List"
            ]
        ),
        .plugin(
            name: "Update Copyright Dates",
            targets: [
                "Update Copyright Dates"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            branch: "0.48.0"
        ),
    ],
    targets: [
        .plugin(
            name: "Reformat Source Code",
            capability: .command(
                intent: .custom(verb: "reformat-source-code", description: "Reformats the Swift source code files using SwiftFormat"),
                permissions: [
                    .writeToPackageDirectory(reason: "This command reformats the Swift source files")
                ]
            ),
            dependencies: [
                .product(name: "swiftformat", package: "SwiftFormat"),
            ]
        ),
        .plugin(
            name: "Regenerate Contributors List",
            capability: .command(
                intent: .custom(verb: "regenerate-contributors-list", description: "Generates the CONTRIBUTORS.txt file based on Git logs"),
                permissions: [
                    .writeToPackageDirectory(reason: "This command write the new copyright dates to the Swift source files")
                ]
            )
        ),
        .plugin(
            name: "Update Copyright Dates",
            capability: .command(
                intent: .custom(verb: "update-copyright-dates", description: "Updates the copyright dates in source files based on Git logs"),
                permissions: [
                    .writeToPackageDirectory(reason: "This command write the new copyright dates to the Swift source files")
                ]
            )
        ),
    ]
)
