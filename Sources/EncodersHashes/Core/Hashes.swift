//
//  Hashes.swift
//  SwiftEncodersHashes
//
//  Cryptographic digests (MD5, SHA-1/256/384/512) as lowercase hex, via CryptoKit.
//
//  Created by David Sherlock on 7/18/26.
//

import Foundation
import CryptoKit

/// One-shot cryptographic digests over a string's UTF-8 bytes (or raw ``Data``), each
/// returned as a **lowercase hex** string. Backed by Apple's CryptoKit.
///
/// `md5` and `sha1` are exposed for interoperability/checksums only — they are
/// cryptographically broken and, accordingly, live under CryptoKit's `Insecure` namespace.
/// Prefer `sha256`+ for anything security-sensitive.
public enum Hashes {

    /// MD5 digest of the string's UTF-8 bytes, as lowercase hex. **Insecure** — checksums
    /// only.
    public static func md5(_ string: String) -> String { md5(Data(string.utf8)) }

    /// MD5 digest of raw bytes, as lowercase hex. **Insecure** — checksums only.
    public static func md5(_ data: Data) -> String { hex(Insecure.MD5.hash(data: data)) }

    /// SHA-1 digest of the string's UTF-8 bytes, as lowercase hex. **Insecure** — checksums
    /// only.
    public static func sha1(_ string: String) -> String { sha1(Data(string.utf8)) }

    /// SHA-1 digest of raw bytes, as lowercase hex. **Insecure** — checksums only.
    public static func sha1(_ data: Data) -> String { hex(Insecure.SHA1.hash(data: data)) }

    /// SHA-256 digest of the string's UTF-8 bytes, as lowercase hex.
    public static func sha256(_ string: String) -> String { sha256(Data(string.utf8)) }

    /// SHA-256 digest of raw bytes, as lowercase hex.
    public static func sha256(_ data: Data) -> String { hex(SHA256.hash(data: data)) }

    /// SHA-384 digest of the string's UTF-8 bytes, as lowercase hex.
    public static func sha384(_ string: String) -> String { sha384(Data(string.utf8)) }

    /// SHA-384 digest of raw bytes, as lowercase hex.
    public static func sha384(_ data: Data) -> String { hex(SHA384.hash(data: data)) }

    /// SHA-512 digest of the string's UTF-8 bytes, as lowercase hex.
    public static func sha512(_ string: String) -> String { sha512(Data(string.utf8)) }

    /// SHA-512 digest of raw bytes, as lowercase hex.
    public static func sha512(_ data: Data) -> String { hex(SHA512.hash(data: data)) }

    /// Render any CryptoKit digest (a byte sequence) as a lowercase hex string.
    private static func hex<D: Sequence>(_ digest: D) -> String where D.Element == UInt8 {
        digest.map { String(format: "%02x", $0) }.joined()
    }
}
