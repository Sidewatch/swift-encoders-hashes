//
//  HexCodec.swift
//  SwiftEncodersHashes
//
//  Hex encode/decode over UTF-8 strings and raw Data.
//
//  Created by David Sherlock on 7/18/26.
//

import Foundation

/// Hexadecimal transforms. Encoding always produces **lowercase** hex with no separators;
/// decoding is case-insensitive and ignores whitespace (so pasted, space-grouped dumps
/// like `"48 69"` decode fine).
///
/// Failure convention: `decode…` returns `nil` — never throws — on an odd number of hex
/// digits, any non-hex character, or (for the `String`-returning variant) bytes that aren't
/// valid UTF-8.
public enum HexCodec {

    /// Lowercase hex of a string's UTF-8 bytes (e.g. `"Hi"` → `"4869"`).
    public static func encode(_ string: String) -> String {
        encode(Data(string.utf8))
    }

    /// Lowercase hex of raw bytes.
    public static func encode(_ data: Data) -> String {
        data.map { String(format: "%02x", $0) }.joined()
    }

    /// Decode a hex string (whitespace ignored, case-insensitive) back to a UTF-8 string,
    /// or `nil` on an odd digit count, a non-hex character, or non-UTF-8 bytes.
    public static func decode(_ string: String) -> String? {
        guard let data = decodeToData(string) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Decode a hex string (whitespace ignored, case-insensitive) to raw bytes, or `nil` on
    /// an odd digit count or a non-hex character.
    public static func decodeToData(_ string: String) -> Data? {
        let digits = string.filter { !$0.isWhitespace }
        guard digits.count % 2 == 0 else { return nil }
        var out = Data()
        out.reserveCapacity(digits.count / 2)
        var it = digits.makeIterator()
        while let hi = it.next(), let lo = it.next() {
            guard let h = hi.hexDigitValue, let l = lo.hexDigitValue else { return nil }
            out.append(UInt8(h << 4 | l))
        }
        return out
    }
}
