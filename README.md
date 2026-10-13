# ShuftiPro-NFC-SPM

Swift Package Manager distribution of the ShuftiPro NFC iOS SDK.

## Requirements

- iOS 15.5+
- Xcode 15+
- A **physical iPhone** (iPhone 7 or newer). The NFC SDK is built for devices only; simulator builds are not supported.

## Integration

### Step 1 — Add the package

In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/shuftipro/ShuftiPro-NFC-SPM
```

choose the version, and add the `ShuftiPro` product to your **app target**.

Its dependencies (OpenSSL, Lottie) are installed automatically through
[shufti-nfc-spm-dependencies](https://github.com/shuftipro/shufti-nfc-spm-dependencies). Do not add them yourself.

### Step 2 — Add the NFC capability (entitlement)

Select your app target → **Signing & Capabilities** → **+ Capability** → **Near Field Communication Tag Reading**.

Xcode creates (or updates) your `.entitlements` file with:

```xml
<key>com.apple.developer.nfc.readersession.formats</key>
<array>
    <string>TAG</string>
</array>
```

> Without this entitlement iOS reports NFC as unavailable and the **Scan now** button does nothing.

### Step 3 — Add the Info.plist keys

Add these to your app's `Info.plist`:

```xml
<!-- Camera: document and face capture -->
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture your document and face.</string>

<!-- NFC: message shown when the chip scan starts -->
<key>NFCReaderUsageDescription</key>
<string>We need NFC access to read the chip in your passport or ID card.</string>

<!-- NFC: chip applications the SDK reads -->
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
    <string>A0000002472001</string>
    <string>00000000000000</string>
</array>
```

Add all three identifiers exactly as listed. `A0000002471001` is the ePassport (ICAO) application;
the other two are needed by some ID cards.

### Step 4 — Start a verification

```swift
import ShuftiPro

class ViewController: UIViewController {
    let instance = Shufti()

    func startVerification() {
        instance.shuftiProVerification(requestObject: requestObject,
                                       authKeys: authKeys,
                                       parentVC: self,
                                       configs: configs) { result in
            let response = result as? NSDictionary
            if response?.value(forKey: "event") as? String == "verification.accepted" {
                // Verified
            } else {
                // Declined
            }
        }
    }
}
```

`requestObject`, `authKeys` and `configs` are the same as in the standard ShuftiPro iOS SDK.

### Step 5 — Run on a device

Build and run on a physical iPhone. If you previously installed the app without the NFC capability,
delete it from the device first so the new entitlement is applied.

## Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| **Scan now** does nothing | NFC entitlement missing | Step 2 |
| NFC scan sheet opens but the chip is never read | `select-identifiers` missing or incomplete | Step 3, all three identifiers |
| Build fails for the simulator | The SDK is device only | Run on a physical iPhone |
| `Library not loaded: @rpath/OpenSSL.framework` | Package added to a framework target instead of the app | Add the `ShuftiPro` product to the app target |

## Releasing

See [RELEASING.md](RELEASING.md).
