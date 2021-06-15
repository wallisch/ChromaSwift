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
                "src/cmd",
                // Other FFT Libs
                "src/fft_lib_avfft.cpp",
                "src/fft_lib_fftw3.cpp",
                "src/fft_lib_kissfft.cpp",
                // Tests
                "src/fft_test.cpp",
                "src/audio/audio_slicer_test.cpp",
                "src/audio/ffmpeg_audio_reader_test.cpp",
                "src/utils/base64_test.cpp",
                "src/utils/rolling_integral_image_test.cpp",
                // Supporting files
                "src/CMakeLists.txt",
                "src/utils/gen_bit_writer.py",
                "src/utils/gen_bit_reader.py",
                "src/utils/update_int_array_utils.sh"
            ],
            sources: [
                // Base
                "src/audio_processor.cpp",
                "src/chroma.cpp",
                "src/chroma_resampler.cpp",
                "src/chroma_filter.cpp",
                "src/spectrum.cpp",
                "src/fft.cpp",
                "src/fingerprinter.cpp",
                "src/image_builder.cpp",
                "src/simhash.cpp",
                "src/silence_remover.cpp",
                "src/fingerprint_calculator.cpp",
                "src/fingerprint_compressor.cpp",
                "src/fingerprint_decompressor.cpp",
                "src/fingerprinter_configuration.cpp",
                "src/fingerprint_matcher.cpp",
                "src/utils/base64.cpp",
                "src/avresample/resample2.c",
                // vDSP
                "src/fft_lib_vdsp.cpp",
                // Main
                "src/chromaprint.cpp"
            ],
            cxxSettings: [
                .define("USE_VDSP"),
                .headerSearchPath("src")
            ],
            linkerSettings: [.linkedFramework("Accelerate")]
        ),
        .testTarget(
            name: "ChromaSwiftTests",
            dependencies: ["ChromaSwift", "DVR"],
            resources: [.copy("Fixtures"), .copy("Resources")]
        ),
        .testTarget(
            name: "CChromaprintTests",
            dependencies: ["CChromaprint"]
        )
    ],
    cxxLanguageStandard: .cxx11
)
