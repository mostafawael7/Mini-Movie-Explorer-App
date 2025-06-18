//
//  GetMovieDetailsUseCase.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 18/06/2025.
//

final class GetMovieDetailsUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> MovieDetails {
        try await repository.fetchMovieDetails(id: id)
    }
}
