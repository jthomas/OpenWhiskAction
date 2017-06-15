// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "OpenWhiskAction",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "15.0.1")
    ]
)
