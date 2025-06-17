//
//  TMDBService.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import Foundation

final class TMDBService {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchPopularMovies(page: Int = 1) async throws -> [Movie] {
        let endpoint = Endpoint(
            path: "/movie/popular",
            method: "GET",
            queryItems: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: "\(page)")
            ],
            headers: [
                "accept": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjQ4YzJhNjY4YmRiMzZiZTYyOTYyZDkwYzhjYTkwMCIsIm5iZiI6MTc1MDE1Njk3OC44NjgsInN1YiI6IjY4NTE0NmIyNzliYTQ2ZjM2M2I2ZGYzNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.sDp6NDjWwoPrF7r6I2hAJuxOHb3xPQ4gNXL2dkM_U4E"
            ]
        )

        let response: MovieResponse = try await apiClient.request(endpoint)
        return response.results.map { $0.toDomain() }
    }
}
