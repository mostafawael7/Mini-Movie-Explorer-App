//
//  MovieRepositoryImpl.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

final class MovieRepositoryImpl: MovieRepository {
    private let service: TMDBService

    init(service: TMDBService) {
        self.service = service
    }

    func fetchPopularMovies(page: Int = 1) async throws -> [Movie] {
        try await service.fetchPopularMovies(page: page)
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetails {
        try await service.getMovieDetails(id: id)
    }
}
