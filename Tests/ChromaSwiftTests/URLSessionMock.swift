// Copyright (c) 2024 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import Foundation
@testable import ChromaSwift

final class URLSessionMock: URLSessionProtocol {
    let url: URL
    let data: Data

    init(url: URL, data: Data) {
        self.url = url
        self.data = data
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard request.url?.absoluteString == self.url.absoluteString else {
            throw URLError(.badURL)
        }
        return (self.data, URLResponse())
    }
}
