// Copyright (c) 2024 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
