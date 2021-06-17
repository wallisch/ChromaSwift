// Copyright (c) 2021 Philipp Wallisch
// Copyright (c) 2016 David Dias
// Distributed under the MIT license, see the LICENSE file for details.

import AVFoundation
import CChromaprint

public class AudioDecoder {
    public enum Error: Swift.Error {
        case invalidFile
        case noValidAudioTracks
        case decodingFailed
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

        let audioTracks = asset.tracks(withMediaType: .audio)
        if audioTracks.isEmpty {
            throw Error.noValidAudioTracks
        }
        let audioTrack = audioTracks.first!

        let sampleRate = chromaprint_get_sample_rate(context)
        let channels = chromaprint_get_num_channels(context)
        let outputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: sampleRate,
            AVNumberOfChannelsKey: channels,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsNonInterleaved: false,
        ]
        let trackOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: outputSettings)

        if chromaprint_start(context, sampleRate, channels) != 1 {
            throw Error.decodingFailed
        }

        reader.add(trackOutput)
        if !reader.startReading() {
            throw Error.decodingFailed
        }

        var remainingSamples = Int.max
        if let maxSampleDuration = maxSampleDuration {
            remainingSamples = Int(maxSampleDuration * Double(channels * sampleRate))
        }

        while reader.status == .reading {
            if let sampleBuffer = trackOutput.copyNextSampleBuffer() {
                if let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
                    let bufferLength = CMBlockBufferGetDataLength(blockBuffer)
                    let sampleCount = bufferLength >> 1

                    let samples = UnsafeMutablePointer<Int16>.allocate(capacity: sampleCount)
                    defer {
                        samples.deallocate()
                    }

                    CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: bufferLength, destination: samples)

                    let samplesToCopy = min(remainingSamples, sampleCount)
                    if chromaprint_feed(context, samples, Int32(samplesToCopy)) != 1 {
                        throw Error.feedingFailed
                    }

                    CMSampleBufferInvalidate(sampleBuffer)

                    if maxSampleDuration != nil {
                        remainingSamples -= samplesToCopy
                        if remainingSamples <= 0 {
                            reader.cancelReading()
                            break
                        }
                    }
                }
            }
        }

        if chromaprint_finish(context) != 1 {
            throw Error.feedingFailed
        }

        return CMTimeGetSeconds(audioTrack.timeRange.duration)
    }
}
