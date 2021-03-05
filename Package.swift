// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "StudyplusSDK-V2",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "StudyplusSDK-V2", targets: ["StudyplusSDK-V2"])
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
    ],
    targets: [
        .target(name: "StudyplusSDK-V2", dependencies: ["KeychainAccess"], path: "Lib/StudyplusSDK"),
    ]
)
