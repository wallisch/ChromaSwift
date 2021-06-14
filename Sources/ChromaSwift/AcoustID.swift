// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import Foundation

public class AcoustID {
    let lookupEndpoint = "https://api.acoustid.org/v2/lookup"
    let apiKey: String
    let timeout: Double

    struct Response: Codable {
        let status: String
        let results: [Result]?
    }

    public struct Result: Codable {
        let id: String
        public let score: Double
        public let recordings: [Recording]?
    }

    public struct Recording: Codable {
        let id: String
        public let duration: Int?
        public let title: String?
        public let artists: [Artist]?
        public let releasegroups: [Releasegroup]?
    }

    public struct Artist: Codable {
        let id: String
        public let name: String?
    }

    public struct Releasegroup: Codable {
        let id: String
        public let type: String?
        public let title: String?
    }

    public init(apiKey: String, timeout: Double = 3.0) {
        self.apiKey = apiKey
        self.timeout = timeout
    }

    public func lookup(_ fingerprint: AudioFingerprint) -> [Result]? {
        guard let base64Fingerprint = fingerprint.fingerprint else { return nil }

        let query = [
            URLQueryItem(name: "client", value: apiKey),
            URLQueryItem(name: "duration", value: String(Int(fingerprint.duration))),
            URLQueryItem(name: "fingerprint", value: base64Fingerprint),
            URLQueryItem(name: "meta", value: "recordings+releasegroups+compress")
        ]
        var lookupURLComponents = URLComponents(string: lookupEndpoint)!
        lookupURLComponents.queryItems = query

        var request = URLRequest(url: lookupURLComponents.url!)
        request.timeoutInterval = timeout

        var results: [Result]?
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let decodedResponse = try? JSONDecoder().decode(Response.self, from: data)
                results = decodedResponse?.results
            }
            semaphore.signal()
        }

        task.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return results
    }
}
