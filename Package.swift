// swift-tools-version:5.9

import PackageDescription

let frameworkRepo = "ShuftiPro-NFC-SPM"
let version = "1.0.1"
let frameworkZip = "ShuftiPro.xcframework.zip"
let checksumValue = "23c14112ed6092dc2f908c868033b8befe1e2a0c1a0abeaef1dcbd38f7643d01" // swift package compute-checksum ShuftiPro.xcframework.zip

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
        .package(url: "https://github.com/shuftipro/shufti-nfc-spm-dependencies.git", exact: "1.1.0")
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
