// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ChromaSwift",
    platforms: [.macOS(.v10_14), .iOS(.v12), .tvOS(.v12)],
    products: [.library(name: "ChromaSwift", targets: ["ChromaSwift"])],
    dependencies: [
        .package(url: "https://github.com/venmo/DVR", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "ChromaSwift",
            dependencies: ["CChromaprint"]
        ),
        .target(
            name: "CChromaprint",
            exclude: [
                // fpcalc
                "cmd",
                // FFMPEG parts
                "avresample",
                // Other FFT Libs
                "fft_lib_avfft.cpp",
                "fft_lib_fftw3.cpp",
                "fft_lib_kissfft.cpp",
                // Testlibs
                "3rdparty",
                // Tests
                "fft_test.cpp",
                "audio/audio_slicer_test.cpp",
                "audio/ffmpeg_audio_reader_test.cpp",
                "utils/base64_test.cpp",
                "utils/rolling_integral_image_test.cpp",
                // Supporting files
                "CMakeLists.txt",
                "utils/gen_bit_writer.py",
                "utils/gen_bit_reader.py",
                "utils/update_int_array_utils.sh"
            ],
            sources: [
                // Base
                "audio_processor.cpp",
                "chroma.cpp",
                "chroma_resampler.cpp",
                "chroma_filter.cpp",
                "spectrum.cpp",
                "fft.cpp",
                "fingerprinter.cpp",
                "image_builder.cpp",
                "simhash.cpp",
                "silence_remover.cpp",
                "fingerprint_calculator.cpp",
                "fingerprint_compressor.cpp",
                "fingerprint_decompressor.cpp",
                "fingerprinter_configuration.cpp",
                "fingerprint_matcher.cpp",
                "utils/base64.cpp",
                // vDSP
                "fft_lib_vdsp.cpp",
                // Main
                "chromaprint.cpp"
            ],
            cxxSettings: [
                .define("USE_VDSP"),
                .define("HAVE_ROUND"),
                .headerSearchPath(".")
            ],
            linkerSettings: [.linkedFramework("Accelerate")]
        ),
        .testTarget(
            name: "ChromaSwiftTests",
            dependencies: ["ChromaSwift", "DVR"],
            resources: [.copy("Fixtures"), .copy("Audio")]
        ),
        .testTarget(
            name: "CChromaprintTests",
            dependencies: ["CChromaprint"]
        )
    ],
    cxxLanguageStandard: .cxx11
)
