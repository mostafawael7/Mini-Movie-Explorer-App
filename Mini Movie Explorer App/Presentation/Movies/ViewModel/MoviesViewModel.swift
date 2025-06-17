//
//  MoviesViewModel.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import Foundation

@MainActor
final class MoviesViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    private let getMoviesUseCase: GetMoviesUseCase

    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true

    init(getMoviesUseCase: GetMoviesUseCase) {
        self.getMoviesUseCase = getMoviesUseCase
    }

    func loadInitialMovies() async {
        currentPage = 1
        hasMorePages = true
        do {
            let fetchedMovies = try await getMoviesUseCase.execute(page: currentPage)
            movies = fetchedMovies
            hasMorePages = !fetchedMovies.isEmpty
        } catch {
            print("Failed to load initial movies:", error)
        }
    }

    func loadNextPageIfNeeded(currentIndex: Int) async {
        guard !isLoading, hasMorePages, currentIndex >= movies.count - 5 else { return }

        isLoading = true
        currentPage += 1
        do {
            let moreMovies = try await getMoviesUseCase.execute(page: currentPage)
            movies.append(contentsOf: moreMovies)
            hasMorePages = !moreMovies.isEmpty
        } catch {
            print("Failed to load more movies:", error)
        }
        isLoading = false
    }

    func movie(at index: Int) -> Movie? {
        guard movies.indices.contains(index) else { return nil }
        return movies[index]
    }

    var numberOfMovies: Int {
        movies.count
    }
}
