# ShuftiPro-NFC-SPM

Swift Package Manager distribution of the ShuftiPro NFC iOS SDK.

## Installation

In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/shuftipro/ShuftiPro-NFC-SPM
```

and add the `ShuftiPro` product to your app target.

Its dependencies (OpenSSL, Lottie) are installed automatically through
[shufti-nfc-spm-dependencies](https://github.com/shuftipro/shufti-nfc-spm-dependencies).

## Requirements

- iOS 15.5+
- A physical device. The NFC SDK is built for devices only; simulator builds are not supported.
- The Near Field Communication Tag Reading capability, plus in `Info.plist`:
  - `NFCReaderUsageDescription`
  - `com.apple.developer.nfc.readersession.iso7816.select-identifiers` containing `A0000002471001` (ePassport applet)

## Releasing

See [RELEASING.md](RELEASING.md).
