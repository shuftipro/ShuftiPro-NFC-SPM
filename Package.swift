// swift-tools-version:5.9

import PackageDescription

let frameworkRepo = "ShuftiPro-NFC-SPM"
let version = "1.0.2"
let frameworkZip = "ShuftiPro.xcframework.zip"
let checksumValue = "01553eafff28710b5969dad00ed9237dadf522ee90a938236904c1285f0510d4" // swift package compute-checksum ShuftiPro.xcframework.zip

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
