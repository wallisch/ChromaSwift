// Copyright 2024 Philipp Wallisch
// SPDX-License-Identifier: MIT

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
