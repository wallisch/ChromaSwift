# ChromaSwift

![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20iOS%20%7C%20tvOS-inactive)
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-success)](https://swift.org/package-manager/)

Swift wrapper for [Chromaprint](https://github.com/acoustid/chromaprint), the audio fingerprint library of the [AcoustID](https://acoustid.org/) project.

## Installation

Add `https://github.com/wallisch/ChromaSwift` as SPM dependency and `import ChromaSwift`.

*Note: You can also `import CChromaprint` to directly interact with Chromaprints C interface.*

## Usage

### Generating fingerprints

``` swift
// Generate fingerprint of audio file by URL
let audioFileURL = URL(fileURLWithPath: "test.mp3")
let testFingerprint = try? AudioFingerprint(from: audioFileURL)

// Optionally, specify the AudioFingerprintAlgorithm (Default: .test2)
// Note that only .test2 fingerprints can be looked up at the AcoustID service
testFingerprint = try? AudioFingerprint(from: audioFileURL, algorithm: .test4)

// And / Or the maximum duration to sample in seconds (Default: 120)
// Pass nil to sample the entire file
testFingerprint = try? AudioFingerprint(from: audioFileURL, maxSampleDuration: 10.0)
```

### Handling fingerprints

``` swift
// Get the algorithm that was used to generate the fingerprint
let algorithm = testFingerprint.algorithm // AudioFingerprint.Algorithm.test2

// Get the duration of the entire file in seconds
let duration = testFingerprint.duration // 46.0

// Get the fingerprint as base64 representation
let base64FingerprintString = testFingerprint.fingerprint

// Get the fingerprints hash as binary string
let binaryHashString = testFingerprint.hash // "01110100010011101010100110100100"

// Instantiate a fingerprint object from its base64 representation and entire file duration
let newFingerprint = try? AudioFingerprint(from: base64FingerprintString!, duration: duration)

// Get similarity to other fingerprint object (0.0 to 1.0)
newFingerprint?.similarity(to: testFingerprint) // 1.0

// Or a hash as binary string
newFingerprint?.similarity(to: "01110100010011101010100110100100") // 1.0

```

### Looking up fingerprints

``` swift
// Init the service with your AcoustID API key
let acoustID = AcoustID(apiKey: "zfkYWDrOqAk")

// Optionally, specify a timeout in seconds (Default: 3.0)
let acoustID = AcoustID(apiKey: "zfkYWDrOqAk", timeout: 5.0)

// Lookup an AudioFingerprint object
acoustID.lookup(newFingerprint) { response in
    switch response {
    case .failure(let error):
        // AcoustID.Error
    case .success(let results):
        // See AcoustID.APIResult for all available properties
        for result in results {
            // Get the matching score (0.0 to 1.0)
            let score = result.score

            for recording in result.recordings! {
                // Get the song title
                let title = recording.title

                // Get the songs artists
                let artists = recording.artists

                // Get the songs release groups (Albums, Singles, etc.)
                let releasegroups = recording.releasegroups
            }
        }
    }
}

```

### Handling errors

``` swift
// Throwing calls throw either AudioDecoder.Error or AudioFingerprint.Error
do {
    let audioFileURL = URL(fileURLWithPath: "Invalid.mp3")
    try AudioFingerprint(from: audioFileURL)
} catch {
    // AudioDecoder.Error.invalidFile
}

do {
    try AudioFingerprint(from: "Invalid")
} catch {
    // AudioFingerprint.Error.invalidFingerprint
}

```
