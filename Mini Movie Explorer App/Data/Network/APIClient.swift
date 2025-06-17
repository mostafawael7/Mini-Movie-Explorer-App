//
//  APIClient.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import Foundation
import Alamofire

protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct Endpoint {
    let path: String
    let method: String
    let queryItems: [URLQueryItem]?
    let headers: [String: String]?

    var url: URL {
        var components = URLComponents(string: "https://api.themoviedb.org/3\(path)")!
        components.queryItems = queryItems
        return components.url!
    }
}

final class DefaultAPIClient: APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let url = endpoint.url

        let httpHeaders = HTTPHeaders(endpoint.headers ?? [:])

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: HTTPMethod(rawValue: endpoint.method),
                parameters: nil,
                encoding: URLEncoding.default,
                headers: httpHeaders
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
