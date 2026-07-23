//
//  EncodersHashesTests.swift
//  Tests for SwiftEncodersHashes
//
//  Created by David Sherlock on 7/18/26.
//

import XCTest
@testable import EncodersHashes

final class EncodersHashesTests: XCTestCase {

    // MARK: - Base64 (standard)

    func testBase64StandardEncode() {
        XCTAssertEqual(Base64.encode("hello"), "aGVsbG8=")
    }

    func testBase64StandardRoundTrip() {
        XCTAssertEqual(Base64.decode(Base64.encode("hello")), "hello")
        XCTAssertEqual(Base64.decode("aGVsbG8="), "hello")
        // Unicode payload survives the UTF-8 round-trip.
        let s = "café — ☕️"
        XCTAssertEqual(Base64.decode(Base64.encode(s)), s)
    }

    func testBase64BadInputReturnsNil() {
        XCTAssertNil(Base64.decode("!!!!"))         // not valid Base64
        XCTAssertNil(Base64.decode("/w=="))         // valid Base64 → byte 0xFF → not UTF-8
    }

    // Regression: unpadded standard-alphabet input was rejected while the URL-safe
    // path re-padded — the standard path now restores '=' padding too.
    func testBase64StandardDecodesUnpaddedInput() {
        XCTAssertEqual(Base64.decode("aGVsbG8"), "hello")            // 3 chars short of a quad
        XCTAssertEqual(Base64.decode("aGk"), "hi")                   // 2-char tail
        XCTAssertEqual(Base64.decodeToData("aGVsbG8"), Data("hello".utf8))
        XCTAssertNil(Base64.decodeToData("aGVsbG8x1"))               // length ≡ 1 (mod 4) is never valid
    }

    // MARK: - Base64 (URL-safe)

    func testBase64URLSafeUsesDashUnderscoreNoPadding() {
        // These bytes produce both '+' and '/' plus '=' padding in the standard alphabet.
        let data = Data([0xF8, 0x00, 0x3F, 0xFF])
        let std = Base64.encode(data)
        XCTAssertTrue(std.contains("+"), std)
        XCTAssertTrue(std.contains("/"), std)
        XCTAssertTrue(std.contains("="), std)

        let url = Base64.encodeURLSafe(data)
        XCTAssertFalse(url.contains("+"), url)
        XCTAssertFalse(url.contains("/"), url)
        XCTAssertFalse(url.contains("="), url)
        XCTAssertEqual(url, "-AA__w")
    }

    func testBase64URLSafeRoundTrip() {
        let data = Data([0xF8, 0x00, 0x3F, 0xFF])
        XCTAssertEqual(Base64.decodeURLSafeToData(Base64.encodeURLSafe(data)), data)

        let s = "https://example.com/a?b=c&d=e"
        XCTAssertEqual(Base64.decodeURLSafe(Base64.encodeURLSafe(s)), s)
    }

    // MARK: - Hex

    func testHexEncode() {
        XCTAssertEqual(HexCodec.encode("Hi"), "4869")
    }

    func testHexDecode() {
        XCTAssertEqual(HexCodec.decode("4869"), "Hi")
        XCTAssertEqual(HexCodec.decode("48 69"), "Hi")     // whitespace ignored
        XCTAssertNil(HexCodec.decode("zz"))                // non-hex
        XCTAssertNil(HexCodec.decode("486"))               // odd length
    }

    func testHexRoundTrip() {
        XCTAssertEqual(HexCodec.decode(HexCodec.encode("round-trip!")), "round-trip!")
    }

    // MARK: - URL percent-encoding

    func testURLEncode() {
        XCTAssertEqual(URLCodec.encode("a b&c"), "a%20b%26c")
    }

    func testURLRoundTrip() {
        XCTAssertEqual(URLCodec.decode(URLCodec.encode("a b&c")), "a b&c")
        XCTAssertEqual(URLCodec.decode("a%20b%26c"), "a b&c")
    }

    // MARK: - Hashes (known vectors)

    func testSHA256ABC() {
        XCTAssertEqual(Hashes.sha256("abc"),
                       "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    }

    func testSHA1ABC() {
        XCTAssertEqual(Hashes.sha1("abc"), "a9993e364706816aba3e25717850c26c9cd0d89d")
    }

    func testMD5ABC() {
        XCTAssertEqual(Hashes.md5("abc"), "900150983cd24fb0d6963f7d28e17f72")
    }

    func testSHA512ABCPrefix() {
        XCTAssertTrue(Hashes.sha512("abc").hasPrefix("ddaf35a193617aba"), Hashes.sha512("abc"))
    }

    func testSHA384ABC() {
        XCTAssertEqual(Hashes.sha384("abc"),
                       "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7")
    }

    func testHashesDataMatchesString() {
        XCTAssertEqual(Hashes.sha256(Data("abc".utf8)), Hashes.sha256("abc"))
        XCTAssertEqual(Hashes.md5(Data("abc".utf8)), Hashes.md5("abc"))
    }

    func testHashesEmptyString() {
        // Well-known empty-input digests.
        XCTAssertEqual(Hashes.md5(""), "d41d8cd98f00b204e9800998ecf8427e")
        XCTAssertEqual(Hashes.sha256(""),
                       "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    }
}
