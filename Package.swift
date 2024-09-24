// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ChromaSwift",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15)],
    products: [.library(name: "ChromaSwift", targets: ["ChromaSwift"])],
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
                "audio",
                "avresample",
                // Other FFT Libs
                "fft_lib_avfft.cpp",
                "fft_lib_fftw3.cpp",
                "fft_lib_kissfft.cpp",
                // Unused
                "chroma_resampler.cpp",
                "fingerprint_matcher.cpp",
                "image_builder.cpp",
                "spectrum.cpp",
                // Testlibs
                "3rdparty",
                // Tests
                "fft_test.cpp",
                "utils/base64_test.cpp",
                "utils/rolling_integral_image_test.cpp",
                // Supporting files
                "CMakeLists.txt",
                "utils/gen_bit_reader.py",
                "utils/gen_bit_writer.py",
                "utils/update_int_array_utils.sh"
            ],
            sources: [
                // Main
                "audio_processor.cpp",
                "chroma.cpp",
                "chromaprint.cpp",
                "chroma_filter.cpp",
                "fft.cpp",
                "fingerprinter.cpp",
                "fingerprint_calculator.cpp",
                "fingerprint_compressor.cpp",
                "fingerprint_decompressor.cpp",
                "fingerprinter_configuration.cpp",
                "simhash.cpp",
                "silence_remover.cpp",
                "utils/base64.cpp",
                // vDSP
                "fft_lib_vdsp.cpp"
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
            dependencies: ["ChromaSwift"],
            resources: [.copy("Audio")]
        ),
        .testTarget(
            name: "CChromaprintTests",
            dependencies: ["CChromaprint"]
        )
    ],
    cxxLanguageStandard: .cxx11
)
