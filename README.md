# ChromaSwift

Swift wrapper for [Chromaprint](https://github.com/acoustid/chromaprint), the audio fingerprint library of the [AcoustID](https://acoustid.org/) project.

## Usage

### Installation

Add `https://github.com/wallisch/ChromaSwift` as Swift Package Manager dependency.

Then just `import ChromaSwift`.

You can also `import CChromaprint` to directly interact with chromaprints C interface.

### Generating fingerprints

``` swift
// Generate fingerprint of audio file by URL
let audioFileURL = URL(fileURLWithPath: "test.mp3")
let testFingerprint = try? AudioFingerprint(from: audioFileURL)

// Optionally, specify the AudioFingerprintAlgorithm (Default: .test2)
testFingerprint = try? AudioFingerprint(from: audioFileURL, algorithm: .test4)

// And / Or the maximum duration to sample in seconds
testFingerprint = try? AudioFingerprint(from: audioFileURL, maxDuration: 10.0)
```

### Handling fingerprints

``` swift
// Get the algorithm that was used to generate the fingerprint
let algorithm = testFingerprint.algorithm // AudioFingerprint.Algorithm.test2

// Get the duration in seconds that was sampled to generate the fingerprint
let duration = testFingerprint.duration // 10.0

// Get the fingerprint as base64 representation
let base64FingerprintString = testFingerprint.fingerprint

// Get the fingerprints hash as binary string
let binaryHashString = testFingerprint.hash // "01110100010011101010100110100100"

// Instantiate a fingerprint object from its base64 representation
let newFingerprint = try? AudioFingerprint(from: base64FingerprintString!, duration: duration)

// Get similarity to other fingerprint object (0.0 to 1.0)
newFingerprint?.similarity(to: testFingerprint) // 1.0

// Or a hash as binary string
newFingerprint?.similarity(to: "01110100010011101010100110100100") // 1.0

```
### Error handling

``` swift
// Throwing calls throw either AudioDecoder.Error or AudioFingerprint.Error
do {
    let audioFileURL = URL(fileURLWithPath: "invalid.mp3")
    try? AudioFingerprint(from: audioFileURL)
} catch {
    // AudioDecoder.Error.invalidFile
}

do {
    try? AudioFingerprint(from: "invalid")
} catch {
    // AudioFingerprint.Error.invalidFingerprint
}

```
