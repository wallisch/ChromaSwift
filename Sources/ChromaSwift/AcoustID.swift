// Copyright (c) 2021 Philipp Wallisch
// Distributed under the MIT license, see the LICENSE file for details.

import Foundation

public class AcoustID {
    let lookupEndpoint = "https://api.acoustid.org/v2/lookup"

    let session: URLSession
    let apiKey: String
    let timeout: Double

    public enum Error: Swift.Error {
        case invalidFingerprint
        case invalidURL
        case networkFail
        case parseFail
        case apiFail
        case invalidApiKey
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

    init(apiKey: String, timeout: Double, session: URLSession) {
        self.session = session
        self.apiKey = apiKey
        self.timeout = timeout
    }

    public convenience init(apiKey: String, timeout: Double = 3.0) {
        self.init(apiKey: apiKey, timeout: timeout, session: .shared)
    }

    public func lookup(_ fingerprint: AudioFingerprint, completion: @escaping (Result<[APIResult], Error>) -> Void) {
        guard let base64Fingerprint = fingerprint.fingerprint else {
            completion(.failure(Error.invalidFingerprint))
            return
        }

        let query = [
            URLQueryItem(name: "client", value: apiKey),
            URLQueryItem(name: "meta", value: "recordings+releasegroups+compress"),
            URLQueryItem(name: "duration", value: String(Int(fingerprint.duration))),
            URLQueryItem(name: "fingerprint", value: base64Fingerprint)
        ]
        var lookupURLComponents = URLComponents(string: lookupEndpoint)!
        lookupURLComponents.queryItems = query

        guard let lookupURL = lookupURLComponents.url else {
            completion(.failure(Error.invalidURL))
            return
        }
        var request = URLRequest(url: lookupURL)
        request.timeoutInterval = timeout

        session.dataTask(with: request) { (data, _, error) in
            if error != nil {
                completion(.failure(Error.networkFail))
            } else if let data = data {
                guard let decodedResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else {
                    completion(.failure(Error.parseFail))
                    return
                }
                if let apiError = decodedResponse.error {
                    switch apiError.code {
                    case 4:
                        completion(.failure(Error.invalidApiKey))
                    default:
                        completion(.failure(Error.apiFail))
                    }
                    return
                }
                guard let results = decodedResponse.results else {
                    completion(.success([]))
                    return
                }
                completion(.success(results))
            }
        }.resume()
    }
}
