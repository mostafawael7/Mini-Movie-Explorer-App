//
//  MovieDetailsViewModel.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 18/06/2025.
//

import Foundation

@MainActor
class MovieDetailsViewModel: ObservableObject {
    @Published var movieDetails: MovieDetails?
    let movieID: Int

    private let useCase: GetMovieDetailsUseCase

    init(movieID: Int, useCase: GetMovieDetailsUseCase) {
        self.movieID = movieID
        self.useCase = useCase
    }

    func loadDetails(for id: Int) async {
        do {
            movieDetails = try await useCase.execute(id: id)
        } catch {
            print("Failed to load details: \(error)")
        }
    }
}
