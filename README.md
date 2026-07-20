# Swift Encoders & Hashes

A dependency-free, read-only toolkit of the everyday developer encode/decode transforms and cryptographic digests — Base64 (standard + URL-safe), hex, URL percent-encoding, and MD5/SHA-1/SHA-256/SHA-384/SHA-512. Foundation + CryptoKit only, pure value-in/value-out logic that never mutates or holds state — built to back a "paste, transform, copy" tool panel.

## Features

- 🅱️ **Base64** — `Base64.encode(_:)` / `decode(_:)` for the standard alphabet and `Base64.encodeURLSafe(_:)` / `decodeURLSafe(_:)` for base64url (`-`/`_`, no padding); string helpers work on UTF-8, plus raw `Data` variants
- 🔟 **Hex** — `HexCodec.encode(_:)` (lowercase, no separators) and `HexCodec.decode(_:)` (case-insensitive, whitespace-ignoring)
- 🔗 **URL percent-encoding** — `URLCodec.encode(_:)` escapes everything outside the RFC 3986 unreserved set; `URLCodec.decode(_:)` reverses it
- #️⃣ **Hashes** — `Hashes.md5/sha1/sha256/sha384/sha512(_:)` over a string's UTF-8 (or raw `Data`), returned as lowercase hex, via CryptoKit
- 🛡 **Never crashes** — decode failures come back as `nil` (bad Base64/hex, malformed escapes, or non-UTF-8 bytes), so a UI can show the result verbatim
- 🪶 **Minimal dependencies** — Foundation + CryptoKit, nothing third-party
- 🍎 **Cross-platform** — iOS, macOS, tvOS, watchOS, visionOS

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ / visionOS 1.0+
- Swift 5.9+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/Sidewatch/swift-encoders-hashes.git", from: "1.0.0")
]
```

## Usage

```swift
import EncodersHashes

// Base64
Base64.encode("hello")                 // "aGVsbG8="
Base64.decode("aGVsbG8=")              // "hello"
Base64.encodeURLSafe(data)             // "-AA__w"  (no '+', '/', or '=')
Base64.decodeURLSafe("-AA__w")         // round-trips

// Hex
HexCodec.encode("Hi")                  // "4869"
HexCodec.decode("48 69")               // "Hi"     (whitespace ignored)
HexCodec.decode("zz")                  // nil      (non-hex)

// URL percent-encoding
URLCodec.encode("a b&c")               // "a%20b%26c"
URLCodec.decode("a%20b%26c")           // "a b&c"

// Hashes (lowercase hex)
Hashes.sha256("abc")                   // "ba7816bf…f20015ad"
Hashes.md5("abc")                      // "900150983cd24fb0d6963f7d28e17f72"
Hashes.sha512(Data(bytes))             // over raw Data too
```

Every `decode…` returns an optional and yields `nil` — never a crash — on malformed input (invalid Base64/hex, a bad percent-escape, or decoded bytes that aren't valid UTF-8).

## License

MIT © 2026 David Sherlock (ArrayPress)
