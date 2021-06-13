// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import Foundation
import CChromaprint

public class AudioFingerprint {
    public let algorithm: Algorithm
    public let duration: Double

    var rawFingerprint: [UInt32]

    public enum Error: Swift.Error {
        case fingerprintingFailed
        case invalidFingerprint
    }

    public enum Algorithm: Int32 {
        case test1 = 0
        case test2
        case test3
        case test4
        case test5
    }

    init(from rawFingerprint: [UInt32], algorithm: Algorithm, duration: Double) {
        self.algorithm = algorithm
        self.duration = duration
        self.rawFingerprint = rawFingerprint
    }

    public convenience init(from url: URL, algorithm: Algorithm = .test2, maxDuration: Double? = 120) throws {
        let context = chromaprint_new(algorithm.rawValue)!
        defer {
            chromaprint_free(context)
        }

        let duration = try AudioDecoder.feed(into: context, from: url, maxDuration: maxDuration)

        var rawFingerprintPointer: UnsafeMutablePointer<UInt32>? = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        defer {
            rawFingerprintPointer?.deallocate()
        }
        var rawFingerprintSize = Int32(0)

        if chromaprint_get_raw_fingerprint(context, &rawFingerprintPointer, &rawFingerprintSize) != 1 {
            throw Error.fingerprintingFailed
        }

        self.init(from: [UInt32](UnsafeBufferPointer(start: rawFingerprintPointer, count: Int(rawFingerprintSize))), algorithm: algorithm, duration: duration)
    }

    public convenience init(from fingerprint: String, duration: Double) throws {
        guard var mutableFingerprint = fingerprint.cString(using: .ascii) else {
            throw Error.invalidFingerprint
        }

        var rawFingerprintPointer: UnsafeMutablePointer<UInt32>? = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        defer {
            rawFingerprintPointer?.deallocate()
        }
        var rawFingerprintSize = Int32(0)
        var algorithm = Int32(0)

        if chromaprint_decode_fingerprint(&mutableFingerprint, Int32(mutableFingerprint.count), &rawFingerprintPointer, &rawFingerprintSize, &algorithm, 1) != 1 {
            throw Error.invalidFingerprint
        }

        self.init(from: [UInt32](UnsafeBufferPointer(start: rawFingerprintPointer, count: Int(rawFingerprintSize))), algorithm: Algorithm(rawValue: algorithm)!, duration: duration)
    }

    public var fingerprint: String? {
        var fingerprint: UnsafeMutablePointer<CChar>?  = UnsafeMutablePointer<CChar>.allocate(capacity: 1)
        defer {
            fingerprint?.deallocate()
        }
        var fingerprintSize = Int32(0)

        if chromaprint_encode_fingerprint(&rawFingerprint, Int32(rawFingerprint.count), algorithm.rawValue, &fingerprint, &fingerprintSize, 1) != 1 {
            return nil
        }

        return String(cString: fingerprint!)
    }

    var rawHash: UInt32? {
        var hash = UInt32(0)

        if chromaprint_hash_fingerprint(&rawFingerprint, Int32(rawFingerprint.count), &hash) != 1 {
            return nil
        }

        return hash
    }

    public var hash: String? {
        guard let rawHash = rawHash else { return nil }

        let binaryString = String(rawHash, radix: 2)

        var paddedBinaryString = binaryString
        for _ in 0..<(32 - binaryString.count) {
            paddedBinaryString = "0" + paddedBinaryString
        }

        return paddedBinaryString
    }

    func similarity(to otherRawHash: UInt32) -> Double? {
        guard let selfRawHash = rawHash else { return nil }
        let diff = selfRawHash ^ otherRawHash
        return Double(32 - String(diff, radix: 2).filter({ $0 == "1" }).count) / Double(32)
    }

    public func similarity(to otherHash: String) -> Double? {
        guard let otherRawHash = UInt32(otherHash, radix: 2) else { return nil }
        return similarity(to: otherRawHash)
    }

    public func similarity(to fingerprint: AudioFingerprint) -> Double? {
        guard let otherRawHash = fingerprint.rawHash else { return nil }
        if algorithm != fingerprint.algorithm { return nil }
        return similarity(to: otherRawHash)
    }
}
