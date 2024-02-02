# ChromaSwift

![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20iOS%20%7C%20tvOS-inactive)
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://swift.org/)
[![SPM](https://img.shields.io/badge/SPM-compatible-success)](https://swift.org/package-manager/)
[![Unit Tests](https://github.com/wallisch/ChromaSwift/actions/workflows/unit_tests.yml/badge.svg)](https://github.com/wallisch/ChromaSwift/actions/workflows/unit_tests.yml)
[![codecov](https://codecov.io/gh/wallisch/ChromaSwift/branch/master/graph/badge.svg?token=Y9IMV4347N)](https://codecov.io/gh/wallisch/ChromaSwift)

Swift wrapper for [Chromaprint](https://github.com/acoustid/chromaprint), the audio fingerprint library of the [AcoustID](https://acoustid.org/) project

## Installation

Add `https://github.com/wallisch/ChromaSwift` as SwiftPM dependency and `import ChromaSwift`

## Usage

### Generating fingerprints

Generate fingerprint of a file containing an audio track by URL. This also works for video files (e.g. music videos)

``` swift
let fileURL = URL(fileURLWithPath: "Test.mp3")
let testFingerprint = try AudioFingerprint(from: fileURL)
```

Optionally, specify the AudioFingerprintAlgorithm (Default: `.test2`)

You can remove leading silence with`.test4`

*Warning: Only `.test2` fingerprints can be looked up at the AcoustID service*

``` swift
let testFingerprint = try AudioFingerprint(from: fileURL, algorithm: .test4)
```

And / Or the maximum duration to sample in seconds (Default: `120`). Pass `nil` to sample the entire file

``` swift
let testFingerprint = try AudioFingerprint(from: fileURL, maxSampleDuration: 10.0)
```

### Handling fingerprints

Get the algorithm that was used to generate the fingerprint

``` swift
let algorithm = testFingerprint.algorithm // AudioFingerprint.Algorithm.test2
```

Get the duration of the entire file in seconds

``` swift
let duration = testFingerprint.duration // 46.0
```

Get the fingerprint in its raw form as an array of unsigned 32 bit integers

``` swift
let rawFingerprint = testFingerprint.raw // [4107342261, 4107276695, ... ]
```

Get the fingerprint as base64 representation

``` swift
let base64FingerprintString = testFingerprint.base64 // "AQABYJGikFSmJBCPijt6Hq..."
```

Get the fingerprints hash as binary string

``` swift
let binaryHashString = testFingerprint.hash // "01110100010011101010100110100100"
```

Instantiate a fingerprint object from its raw form, algorithm and and entire file duration

``` swift
let newFingerprint = AudioFingerprint(from: rawFingerprint, algorithm: .test2, duration: duration)
```

Instantiate a fingerprint object from its base64 representation and entire file duration

``` swift
let newFingerprint = try AudioFingerprint(from: base64FingerprintString, duration: duration)
```

Get similarity to other fingerprint object (`0.0` to `1.0`)

``` swift
let similarity = try newFingerprint.similarity(to: testFingerprint) // 1.0
```

Optionally, ignore sample duration differences greater than 20% between fingerprints (Default: `false`)

This is useful if you want to e.g. check if a a longer mix contains a specific track

*Warning: This can lead to wrong results when comparing with Fingerprints sampled for a very short duration*

``` swift
try newFingerprint.similarity(to: testFingerprint, ignoreSampleDuration: true) // 1.0
```

You can also get the similarity to a fingerprint hash

*Warning: This is less accurate than comparing fingerprint objects, especially if the algorithms don't match*

``` swift
try newFingerprint.similarity(to: binaryHashString) // 1.0
```

### Looking up fingerprints

Init the service with your AcoustID API key

``` swift
let acoustID = AcoustID(apiKey: "zfkYWDrOqAk")
```

Optionally, specify a timeout in seconds (Default: `3.0`)

``` swift
let acoustID = AcoustID(apiKey: "zfkYWDrOqAk", timeout: 10.0)
```

Lookup an AudioFingerprint object

``` swift
acoustID.lookup(newFingerprint) { response in
    switch response {
    case .failure(let error):
        // AcoustID.Error
    case .success(let results):
        // [AcoustID.APIResult]
        for result in results {
            // Matching score (0.0 to 1.0)
            let score = result.score

            for recording in result.recordings! {
                // Song title
                let title = recording.title

                // Song artists
                let artists = recording.artists

                // Song release groups (Albums, Singles, etc.)
                let releasegroups = recording.releasegroups
            }
        }
    }
}
```

### Handling errors

Throwing calls throw either an `AudioDecoder.Error`

``` swift
do {
    let fileURL = URL(fileURLWithPath: "Invalid.mp3")
    try AudioFingerprint(from: fileURL)
} catch {
    // AudioDecoder.Error.invalidFile
}
```

Or an `AudioFingerprint.Error`

``` swift
do {
    try AudioFingerprint(from: "Invalid", duration: 46.0)
} catch {
    // AudioFingerprint.Error.invalidFingerprint
}
```

### Accessing Chromaprints C API

You can also `import CChromaprint` to directly interact with Chromaprints C interface. Please refer to the official documentation for further information.

*Note: To avoid licensing issues, CChromaprint has internal input resampling disabled and thus requires that input audio for the fingerprinter is already at the configured fingerprint sample rate.*
