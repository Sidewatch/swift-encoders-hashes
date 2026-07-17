//
//  URLCodec.swift
//  SwiftEncodersHashes
//
//  URL percent-encoding encode/decode (RFC 3986 unreserved set).
//
//  Created by David Sherlock on 7/18/26.
//

import Foundation

/// URL percent-encoding transforms. Encoding percent-escapes **everything that isn't an
/// RFC 3986 *unreserved* character** — i.e. only `A–Z a–z 0–9 - . _ ~` pass through
/// literally, so spaces, `&`, `/`, `?`, `=`, and non-ASCII bytes are all escaped. This is
/// the strict "encode a value for safe use anywhere in a URL" behaviour.
///
/// Failure convention: `decode(_:)` returns `nil` — never throws — when the input contains
/// a malformed percent-escape.
public enum URLCodec {

    /// The RFC 3986 unreserved set: the only characters left un-escaped by ``encode(_:)``.
    private static let unreserved = CharacterSet(
        charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    )

    /// Percent-encode a string, escaping every character outside the RFC 3986 unreserved
    /// set (e.g. `"a b&c"` → `"a%20b%26c"`).
    public static func encode(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: unreserved) ?? string
    }

    /// Decode percent-escapes back to the original string, or `nil` if the input contains a
    /// malformed escape sequence.
    public static func decode(_ string: String) -> String? {
        string.removingPercentEncoding
    }
}
