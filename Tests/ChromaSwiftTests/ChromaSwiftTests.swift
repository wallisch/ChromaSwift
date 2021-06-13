// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import XCTest
import ChromaSwift

class ChromaSwiftTests: XCTestCase {
    func testInvalidFile() {
        XCTAssertThrowsError(try AudioFingerprint(from: URL(fileURLWithPath: "invalid.mp3"))) { error in
            XCTAssertEqual(error as! AudioDecoder.Error, AudioDecoder.Error.invalidFile)
        }
    }

    func testInvalidFingerprint() {
        XCTAssertThrowsError(try AudioFingerprint(from: "invalid", duration: 2.0)) { error in
            XCTAssertEqual(error as! AudioFingerprint.Error, AudioFingerprint.Error.invalidFingerprint)
        }
    }
}
