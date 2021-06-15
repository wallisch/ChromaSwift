// Copyright (c) 2021 Philipp Wallisch
// Copyright (c) 2016 David Dias
// Distributed under the MIT license, see the LICENSE file for details.

import AVFoundation
import CChromaprint

public class AudioDecoder {
    public enum Error: Swift.Error {
        case invalidFile
        case noAudioTracks
        case invalidAudioTrack
        case feedingFailed
    }

    static func feed(into context: OpaquePointer, from url: URL, maxSampleDuration: Double?) throws -> Double {
        let asset = AVURLAsset(url: url)
        let reader: AVAssetReader

        do {
            reader = try AVAssetReader(asset: asset)
        } catch {
            throw Error.invalidFile
        }

        let audioTracks = asset.tracks(withMediaType: AVMediaType.audio)
        if audioTracks.isEmpty {
            throw Error.noAudioTracks
        }
        let audioTrack = audioTracks.first!

        let sampleRate = chromaprint_get_sample_rate(context)
        let outputSettings: [String: Int] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: Int(sampleRate),
            AVLinearPCMIsBigEndianKey: 0,
            AVLinearPCMIsFloatKey: 0,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsNonInterleaved: 0
        ]
        let trackOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: outputSettings)

        let duration = CMTimeGetSeconds(audioTrack.timeRange.duration)
        let maxSampleDuration = maxSampleDuration ?? duration

        var sampleChannels: Int32?
        for description in audioTrack.formatDescriptions {
            let audioDescription = description as! CMAudioFormatDescription
            let basicDescription = CMAudioFormatDescriptionGetStreamBasicDescription(audioDescription)?.pointee
            if basicDescription?.mChannelsPerFrame != 0 {
                sampleChannels = Int32((basicDescription?.mChannelsPerFrame)!)
            }
        }
        guard let channels = sampleChannels else {
            throw Error.invalidAudioTrack
        }

        if chromaprint_start(context, sampleRate, channels) != 1 {
            throw Error.feedingFailed
        }

        reader.add(trackOutput)
        reader.startReading()
        var remainingSamples = Int32((maxSampleDuration * Double(channels) * Double(sampleRate)).rounded(.up))

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

                    if chromaprint_feed(context, samples, length) != 1 {
                        throw Error.feedingFailed
                    }

                    CMSampleBufferInvalidate(sampleBufferRef)

                    remainingSamples -= length
                    if remainingSamples <= 0 {
                        break
                    }
                }
            }
        }

        if chromaprint_finish(context) != 1 {
            throw Error.feedingFailed
        }

        return duration
    }
}
