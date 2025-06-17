//
//  GetMoviesUseCase.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

final class GetMoviesUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(page: Int = 1) async throws -> [Movie] {
        try await repository.fetchPopularMovies(page: page)
    }
}
