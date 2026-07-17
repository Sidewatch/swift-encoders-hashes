//
//  Base64.swift
//  SwiftEncodersHashes
//
//  Base64 encode/decode over UTF-8 strings and raw Data — standard and URL-safe (base64url).
//
//  Created by David Sherlock on 7/18/26.
//

import Foundation

/// Base64 transforms for a "developer scratchpad" panel. String helpers operate on the
/// **UTF-8 bytes** of the input and, on decode, interpret the result back as a UTF-8
/// string; raw ``Data`` helpers are provided for binary payloads.
///
/// Two alphabets are supported: **standard** (`A–Z a–z 0–9 + /`, `=` padded) and
/// **URL-safe** base64url (`-` and `_` in place of `+`/`/`, padding dropped).
///
/// Failure convention: every `decode…` returns `nil` — never throws, never crashes — when
/// the input isn't valid Base64 (or, for the `String`-returning variants, when the decoded
/// bytes aren't valid UTF-8).
public enum Base64 {

    // MARK: - Standard

    /// Standard Base64 of a string's UTF-8 bytes (e.g. `"hello"` → `"aGVsbG8="`).
    public static func encode(_ string: String) -> String {
        encode(Data(string.utf8))
    }

    /// Standard Base64 of raw bytes.
    public static func encode(_ data: Data) -> String {
        data.base64EncodedString()
    }

    /// Decode standard Base64 back to a UTF-8 string, or `nil` if the input isn't valid
    /// Base64 or the decoded bytes aren't valid UTF-8.
    public static func decode(_ string: String) -> String? {
        guard let data = decodeToData(string) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Decode standard Base64 to raw bytes, or `nil` if the input isn't valid Base64.
    public static func decodeToData(_ string: String) -> Data? {
        Data(base64Encoded: string)
    }

    // MARK: - URL-safe (base64url, no padding)

    /// URL-safe Base64 (base64url) of a string's UTF-8 bytes: `+`→`-`, `/`→`_`, no `=`
    /// padding.
    public static func encodeURLSafe(_ string: String) -> String {
        encodeURLSafe(Data(string.utf8))
    }

    /// URL-safe Base64 (base64url) of raw bytes: `+`→`-`, `/`→`_`, no `=` padding.
    public static func encodeURLSafe(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    /// Decode URL-safe Base64 (with or without padding) back to a UTF-8 string, or `nil`
    /// if the input isn't valid base64url or the decoded bytes aren't valid UTF-8.
    public static func decodeURLSafe(_ string: String) -> String? {
        guard let data = decodeURLSafeToData(string) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Decode URL-safe Base64 (with or without padding) to raw bytes, or `nil` if the input
    /// isn't valid base64url. `-`/`_` are mapped back to `+`/`/` and `=` padding is
    /// restored before decoding.
    public static func decodeURLSafeToData(_ string: String) -> Data? {
        var s = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        switch s.count % 4 {
        case 0: break
        case 2: s += "=="
        case 3: s += "="
        default: return nil   // length ≡ 1 (mod 4) is never valid Base64
        }
        return Data(base64Encoded: s)
    }
}
