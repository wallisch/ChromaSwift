// Copyright 2021, 2024 Philipp Wallisch
// SPDX-License-Identifier: MIT

import Foundation
import CChromaprint

public class AudioFingerprint {
    public let algorithm: Algorithm
    public let duration: Double

    var rawFingerprint: [UInt32]

    public enum Error: Swift.Error {
        case fingerprintingFailed
        case invalidDuration
        case invalidFingerprint
        case invalidHash
        case differentAlgorithm
        case sampleDurationDifference
    }

    public enum Algorithm: Int32 {
        case test1 = 0
        case test2
        case test3
        case test4
        case test5
    }

    public init(from raw: [UInt32], algorithm: Algorithm, duration: Double) {
        self.algorithm = algorithm
        self.duration = duration
        self.rawFingerprint = raw
    }

    public convenience init(from url: URL, algorithm: Algorithm = .test2, maxSampleDuration: Double? = 120) throws {
        let context = chromaprint_new(algorithm.rawValue)!
        defer {
            chromaprint_free(context)
        }

        let duration = try AudioDecoder.feed(into: context, from: url, maxSampleDuration: maxSampleDuration)

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

    public convenience init(from base64: String, duration: Double) throws {
        if duration <= 0 {
            throw Error.invalidDuration
        }

        if base64.isEmpty {
            throw Error.invalidFingerprint
        }

        guard var mutableBase64 = base64.cString(using: .ascii) else {
            throw Error.invalidFingerprint
        }

        var rawFingerprintPointer: UnsafeMutablePointer<UInt32>? = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        defer {
            rawFingerprintPointer?.deallocate()
        }
        var rawFingerprintSize = Int32(0)
        var algorithm = Int32(0)

        if chromaprint_decode_fingerprint(&mutableBase64, Int32(mutableBase64.count), &rawFingerprintPointer, &rawFingerprintSize, &algorithm, 1) != 1 {
            throw Error.invalidFingerprint
        }

        self.init(from: [UInt32](UnsafeBufferPointer(start: rawFingerprintPointer, count: Int(rawFingerprintSize))), algorithm: Algorithm(rawValue: algorithm)!, duration: duration)
    }

    public var raw: [UInt32] {
        return rawFingerprint
    }

    public var base64: String {
        var base64Pointer: UnsafeMutablePointer<CChar>?  = UnsafeMutablePointer<CChar>.allocate(capacity: 1)
        defer {
            base64Pointer?.deallocate()
        }
        var base64Size = Int32(0)

        chromaprint_encode_fingerprint(&rawFingerprint, Int32(rawFingerprint.count), algorithm.rawValue, &base64Pointer, &base64Size, 1)

        return String(cString: base64Pointer!)
    }

    @available(*, deprecated, renamed: "base64")
    public var fingerprint: String {
        return base64
    }

    var rawHash: UInt32 {
        var hash = UInt32(0)

        chromaprint_hash_fingerprint(&rawFingerprint, Int32(rawFingerprint.count), &hash)

        return hash
    }

    public var hash: String {
        let binaryString = String(rawHash, radix: 2)

        var paddedBinaryString = binaryString
        for _ in 0..<(32 - binaryString.count) {
            paddedBinaryString = "0" + paddedBinaryString
        }

        return paddedBinaryString
    }

    func similarity(to rawHash: UInt32) -> Double {
        return Double(32 - (self.rawHash ^ rawHash).nonzeroBitCount) / Double(32)
    }

    public func similarity(to hash: String) throws -> Double {
        guard let rawHash = UInt32(hash, radix: 2) else {
            throw Error.invalidHash
        }
        return similarity(to: rawHash)
    }

    public func similarity(to fingerprint: AudioFingerprint, ignoreSampleDuration: Bool = false) throws -> Double {
        if fingerprint.algorithm != algorithm {
            throw Error.differentAlgorithm
        }

        let sampleDifference = fingerprint.rawFingerprint.count - rawFingerprint.count
        let biggerFingerprint = sampleDifference.signum() >= 0 ? fingerprint.rawFingerprint : rawFingerprint
        let smallerFingerprint = sampleDifference.signum() >= 0 ? rawFingerprint : fingerprint.rawFingerprint

        if !ignoreSampleDuration && abs(sampleDifference) > Int(Double(biggerFingerprint.count) * 0.2) {
            throw Error.sampleDurationDifference
        }

        var smallestError = Int.max
        for offset in 0...abs(sampleDifference) {
            var error = 0
            for (index, value) in smallerFingerprint.enumerated() {
                error += (value ^ biggerFingerprint[index + offset]).nonzeroBitCount
            }
            smallestError = error < smallestError ? error : smallestError
        }

        return 1 - Double(smallestError) / 32 / Double(smallerFingerprint.count)
    }
}
