# Releasing a New Version

This guide describes how to release a new version of the ShuftiPro NFC iOS SDK through Swift Package Manager (SPM).

Each release requires the following to match:

1. SDK version in `Package.swift`
2. Git tag
3. SHA-256 checksum of the XCFramework ZIP
4. GitHub Release with the updated ZIP asset

## Step 1 — Build the XCFramework (in `ios-onsite-sdk`)

```bash
xcodebuild archive -workspace ShuftiPro.xcworkspace \
  -scheme ShuftiPro \
  -sdk iphoneos \
  -archivePath "archives/ios_devices.xcarchive" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

xcodebuild -create-xcframework \
  -framework archives/ios_devices.xcarchive/Products/Library/Frameworks/ShuftiPro.framework \
  -output build/ShuftiPro.xcframework
```

## Step 2 — Check the XCFramework

Run these from `ios-onsite-sdk`. Each one catches a problem that only shows up in client apps.

```bash
FW=build/ShuftiPro.xcframework/ios-arm64/ShuftiPro.framework

# 1. Only OpenSSL and Lottie may be loaded from outside (ML Kit and Google libraries are inside ShuftiPro).
otool -L $FW/ShuftiPro | grep @rpath

# 2. No ML Kit modules in the public interface (clients do not have them). Must print nothing.
grep -h "import MLKit" $FW/Modules/ShuftiPro.swiftmodule/*.swiftinterface

# 3. ML Kit text-recognition models are inside the framework.
ls $FW/LatinOCRResources.bundle
```

Expected for check 1: `@rpath/ShuftiPro.framework/ShuftiPro`, `@rpath/OpenSSL.framework/OpenSSL` and `@rpath/Lottie.framework/Lottie`.

## Step 3 — Replace the XCFramework ZIP

```bash
cd build
rm -f ShuftiPro.xcframework.zip
zip -ry ShuftiPro.xcframework.zip ShuftiPro.xcframework
```

Copy the ZIP into this repository, replacing the existing `ShuftiPro.xcframework.zip`.

Ensure the ZIP contains `ShuftiPro.xcframework` at its root:

```bash
unzip -l ShuftiPro.xcframework.zip | head
```

## Step 4 — Calculate the Checksum

```bash
swift package compute-checksum ShuftiPro.xcframework.zip
```

## Step 5 — Update Package.swift

```swift
let version = "X.Y.Z"
let checksumValue = "YOUR_NEW_CHECKSUM"
```

If the dependencies changed, also update the `shufti-nfc-spm-dependencies` version.

Validate the manifest:

```bash
swift package dump-package
```

## Step 6 — Commit and Push Changes

```bash
git add Package.swift ShuftiPro.xcframework.zip
git commit -m "Release X.Y.Z"
git push origin main
```

## Step 7 — Create and Push the Git Tag

```bash
git tag X.Y.Z
git push origin X.Y.Z
```

## Step 8 — Publish the GitHub Release

Upload the ZIP file as an asset with the exact filename `ShuftiPro.xcframework.zip`:

```bash
gh release create X.Y.Z ShuftiPro.xcframework.zip \
  --title "X.Y.Z" \
  --notes "SDK Release X.Y.Z"
```

## Step 9 — Validate the Release

```bash
curl -sIL https://github.com/shuftipro/ShuftiPro-NFC-SPM/releases/download/X.Y.Z/ShuftiPro.xcframework.zip | grep -i "^HTTP"
```

Confirm that the release asset returns HTTP 200, then test from a clean checkout:

```bash
swift package resolve
```

## Important Notes

- Always calculate the checksum after replacing the ZIP.
- The version in `Package.swift`, Git tag, and GitHub Release must match.
- The uploaded ZIP filename must match the filename referenced in `Package.swift`.
- Publish the GitHub Release immediately after pushing the tag.
- The SDK is device only (`-sdk iphoneos`): client apps cannot build for the simulator.
