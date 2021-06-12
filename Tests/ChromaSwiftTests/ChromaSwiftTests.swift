// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import XCTest
import ChromaSwift

class ChromaSwiftTests: XCTestCase {
    func testInvalidFile() {
        XCTAssertThrowsError(try ChromaSwift.generateFingerprint(fromURL: URL(fileURLWithPath: "nothing"))) { error in
            XCTAssertEqual(error as! ChromaSwiftError, ChromaSwiftError.invalidFile)
        }
    }

    func testInvalidFingerprint() {
        XCTAssertThrowsError(try AudioFingerprint(fingerprint: "test", duration: 2.0)) { error in
            XCTAssertEqual(error as! ChromaSwiftError, ChromaSwiftError.invalidFingerprint)
        }
    }
}
