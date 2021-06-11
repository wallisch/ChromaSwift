// Copyright (c) 2021 Philipp Wallisch
// Copyright (c) 2016 David Dias
// Distributed under the MIT license, see the LICENSE file for details.

import AVFoundation
import CChromaprint

public enum FingerprintingAlgorithm: Int32 {
    case test1 = 0
    case test2
    case test3
    case test4
    case test5
}

public enum ChromaSwiftError: Error {
    case invalidFile
    case noAudioTracks
    case invalidAudioTrack
    case fingerprintingFailed
    case invalidFingerprint
}

public struct ChromaSwift {
    public func generateFingerprint(fromURL url: URL, algorithm: FingerprintingAlgorithm = .test2, maxDuration: Double? = nil) throws -> AudioFingerprint {
        let context = chromaprint_new(algorithm.rawValue)!
        defer {
            chromaprint_free(context)
        }

        let sampleDuration = try decodeAudio(context: context, url: url, maxDuration: maxDuration)

        var rawFingerprintPointer: UnsafeMutablePointer<UInt32>? = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        defer {
            rawFingerprintPointer?.deallocate()
        }
        var rawFingerprintSize = Int32(0)

        if chromaprint_get_raw_fingerprint(context, &rawFingerprintPointer, &rawFingerprintSize) != 1 {
            throw ChromaSwiftError.fingerprintingFailed
        }

        let rawFingerprint = [UInt32](UnsafeBufferPointer(start: rawFingerprintPointer, count: Int(rawFingerprintSize)))

        return AudioFingerprint(rawFingerprint: rawFingerprint, algorithm: algorithm, duration: sampleDuration)
    }

    func decodeAudio(context: OpaquePointer, url: URL, maxDuration: Double?) throws -> Double {
        let asset = AVURLAsset(url: url)
        let reader: AVAssetReader

        do {
            reader = try AVAssetReader(asset: asset)
        } catch {
            throw ChromaSwiftError.invalidFile
        }

        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        if audioTracks.isEmpty {
            throw ChromaSwiftError.noAudioTracks
        }
        let audioTrack = audioTracks.first!

        let outputSettings: [String: Int] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVLinearPCMIsBigEndianKey: 0,
            AVLinearPCMIsFloatKey: 0,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsNonInterleaved: 0
        ]
        let trackOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: outputSettings)

        let duration = CMTimeGetSeconds(audioTrack.timeRange.duration)
        let maxDuration = maxDuration ?? duration

        var sampleRate: Int32?
        var sampleChannels: Int32?
        for description in audioTrack.formatDescriptions {
            let audioDescription = description as! CMAudioFormatDescription
            let basicDescription = CMAudioFormatDescriptionGetStreamBasicDescription(audioDescription)?.pointee
            if basicDescription?.mSampleRate != 0 {
                sampleRate = Int32((basicDescription?.mSampleRate)!)
            }
            if basicDescription?.mChannelsPerFrame != 0 {
                sampleChannels = Int32((basicDescription?.mChannelsPerFrame)!)
            }
        }
        guard let rate = sampleRate, let channels = sampleChannels else {
            throw ChromaSwiftError.invalidAudioTrack
        }

        chromaprint_start(context, rate, channels)

        reader.add(trackOutput)
        reader.startReading()
        var remainingSamples = Int32((maxDuration * Double(channels) * Double(rate)).rounded(.up))

        while reader.status == AVAssetReader.Status.reading {
            if let sampleBufferRef = trackOutput.copyNextSampleBuffer() {
                if let blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef) {
                    let bufferLength = CMBlockBufferGetDataLength(blockBufferRef)

                    let samples = UnsafeMutablePointer<Int16>.allocate(capacity: bufferLength)
                    defer {
                        samples.deallocate()
                    }

                    CMBlockBufferCopyDataBytes(blockBufferRef, atOffset: 0, dataLength: bufferLength, destination: samples)

                    let sampleCount = Int32(bufferLength >> 1)
                    let length = min(remainingSamples, sampleCount)

                    chromaprint_feed(context, samples, length)

                    CMSampleBufferInvalidate(sampleBufferRef)

                    remainingSamples -= length
                    if remainingSamples <= 0 {
                        break
                    }
                }
            }
        }

        chromaprint_finish(context)
        return min(maxDuration, duration)
    }
}
