// swift-tools-version:5.9

import PackageDescription

let frameworkRepo = "ShuftiPro-NFC-SPM"
let version = "1.0.0"
let frameworkZip = "ShuftiPro.xcframework.zip"
let checksumValue = "749007725f4a02f51f00e37a6e1e662cc563d2c03f62fa87494bc5b9c1bafe78" // swift package compute-checksum ShuftiPro.xcframework.zip

let package = Package(
    name: "ShuftiPro-NFC-SPM",
    platforms: [
        .iOS("15.5")
    ],
    products: [
        .library(
            name: "ShuftiPro",
            // ShuftiProNFCDependencies makes Xcode embed OpenSSL and Lottie in the client app,
            // which ShuftiPro.framework loads at runtime.
            targets: ["ShuftiPro", "ShuftiProNFCDependencies"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/shuftipro/shufti-nfc-spm-dependencies.git", exact: "1.0.0")
    ],
    targets: [
        .binaryTarget(
            name: "ShuftiPro",
            url: "https://github.com/shuftipro/\(frameworkRepo)/releases/download/\(version)/\(frameworkZip)",
            checksum: checksumValue
        ),
        .target(
            name: "ShuftiProNFCDependencies",
            dependencies: [
                .product(name: "ShuftiNFCDependencies", package: "shufti-nfc-spm-dependencies")
            ],
            path: "Sources/ShuftiProNFCDependencies"
        )
    ]
)
