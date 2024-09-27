// Copyright 2021, 2024 Philipp Wallisch
// SPDX-License-Identifier: MIT

import Foundation

public class AcoustID {
    let lookupEndpoint = "https://api.acoustid.org/v2/lookup"

    let session: URLSessionProtocol
    let apiKey: String
    let timeout: Double

    public enum Error: Swift.Error {
        case invalidURL
        case networkFail
        case parseFail
        case invalidFingerprint
        case invalidApiKey
        case invalidDuration
        case tooManyRequests
        case apiFail
    }

    struct APIResponse: Codable {
        let status: String
        let error: APIError?
        let results: [APIResult]?
    }

    struct APIError: Codable {
        let code: Int
        let message: String
    }

    public struct APIResult: Codable {
        public let id: String
        public let score: Double
        public let recordings: [Recording]?
    }

    public struct Recording: Codable {
        public let id: String
        public let duration: Int?
        public let title: String?
        public let artists: [Artist]?
        public let releasegroups: [ReleaseGroup]?
    }

    public struct Artist: Codable {
        public let id: String
        public let name: String?
    }

    public struct ReleaseGroup: Codable {
        public let id: String
        public let type: String?
        public let title: String?
    }

    init(apiKey: String, timeout: Double, session: URLSessionProtocol) {
        self.session = session
        self.apiKey = apiKey
        self.timeout = timeout
    }

    public convenience init(apiKey: String, timeout: Double = 3.0) {
        self.init(apiKey: apiKey, timeout: timeout, session: URLSession.shared)
    }

    public func lookup(_ fingerprint: AudioFingerprint) async throws -> [APIResult] {
        let query = [
            URLQueryItem(name: "client", value: apiKey),
            URLQueryItem(name: "meta", value: "recordings+releasegroups+compress"),
            URLQueryItem(name: "duration", value: String(UInt(fingerprint.duration))),
            URLQueryItem(name: "fingerprint", value: fingerprint.base64)
        ]
        var lookupURLComponents = URLComponents(string: lookupEndpoint)!
        lookupURLComponents.queryItems = query

        guard let lookupURL = lookupURLComponents.url else {
            throw Error.invalidURL
        }
        var request = URLRequest(url: lookupURL)
        request.timeoutInterval = timeout

        guard let (data, _) = try? await session.data(for: request) else {
            throw Error.networkFail
        }

        guard let decodedResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else {
            throw Error.parseFail
        }

        if let apiError = decodedResponse.error {
            switch apiError.code {
            case 3:
                throw Error.invalidFingerprint
            case 4:
                throw Error.invalidApiKey
            case 8:
                throw Error.invalidDuration
            case 14:
                throw Error.tooManyRequests
            default:
                throw Error.apiFail
            }
        }

        guard let results = decodedResponse.results else {
            return []
        }

        return results
    }
}
