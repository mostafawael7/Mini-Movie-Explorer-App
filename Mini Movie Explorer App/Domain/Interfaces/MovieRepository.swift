//
//  MovieRepository.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

protocol MovieRepository {
    func fetchPopularMovies(page: Int) async throws -> [Movie]
}
