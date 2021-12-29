// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import XCTest
import CChromaprint

class CChromaprintTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(String(cString: chromaprint_get_version()), "1.5.1")
    }
}
