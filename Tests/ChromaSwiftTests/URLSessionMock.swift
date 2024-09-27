// Copyright 2024 Philipp Wallisch
// SPDX-License-Identifier: MIT

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
