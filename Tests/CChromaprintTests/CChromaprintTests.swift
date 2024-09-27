// Copyright 2021 Philipp Wallisch
// SPDX-License-Identifier: MIT

import XCTest
import CChromaprint

class CChromaprintTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(String(cString: chromaprint_get_version()), "1.5.1")
    }
}
