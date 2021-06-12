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
let testFingerprint = try? ChromaSwift.generateFingerprint(fromURL: audioFileURL)

// Optionally, specify the chromaprint algorithm (FingerprintingAlgorithm)
testFingerprint = try? ChromaSwift.generateFingerprint(fromURL: audioFileURL, algorithm: .test4)

// And/Or the maximum duration in seconds to sample
testFingerprint = try? ChromaSwift.generateFingerprint(fromURL: audioFileURL, maxDuration: 10.0)
```

### Handling fingerprints

``` swift
// Get the algorithm that was used to generate the fingerprint
let algorithm = testFingerprint.algorithm

// Get the duration in seconds that was sampled to generate the fingerprint
let sampleDuration = testFingerprint.sampleDuration // 10.0

// Get the fingerprint as base64 string
let base64Fingerprint = testFingerprint.fingerprint

// Get the fingerprints hash as binary string
let binaryHashString = testFingerprint.hash // "01110100010011101010100110100100"

// Instantiate a fingerprint object from its base64 string
let newFingerprint = try? AudioFingerprint(fingerprint: base64Fingerprint!)

// Get similarity to other fingerprint object (0.0 to 1.0)
newFingerprint?.similarity(to: testFingerprint) // 1.0

// Or a hash as binary string
newFingerprint?.similarity(to: "01110100010011101010100110100100") // 1.0

```
### Error handling

All throwing calls will throw an instance of `ChromaSwiftError`.
