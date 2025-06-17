//
//  MoviesVC.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import UIKit

class MoviesVC: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private var viewModel: MoviesViewModel!
    private var favoriteMovieIDs = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let apiClient = DefaultAPIClient()
        let service = TMDBService(apiClient: apiClient)
        let repo = MovieRepositoryImpl(service: service)
        let useCase = GetMoviesUseCase(repository: repo)
        viewModel = MoviesViewModel(getMoviesUseCase: useCase)

        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")

        Task {
            await viewModel.loadInitialMovies()
            moviesCollectionView.reloadData()
        }
    }
}

extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let movie = viewModel.movie(at: indexPath.item) {
            cell.movie = movie
            cell.delegate = self
            let imageName = favoriteMovieIDs.contains(movie.id) ? "heart.fill" : "heart"
            cell.favoriteBtn.setImage(UIImage(systemName: imageName), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(viewModel.movies[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        Task {
            await viewModel.loadNextPageIfNeeded(currentIndex: indexPath.item)
            collectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 300)
    }
}

extension MoviesVC: MovieCellDelegate {
    func movieCell(_ cell: MovieCell, didTapFavoriteFor movie: Movie) {
        if favoriteMovieIDs.contains(movie.id) {
            favoriteMovieIDs.remove(movie.id)
        } else {
            favoriteMovieIDs.insert(movie.id)
        }

        if let indexPath = moviesCollectionView.indexPath(for: cell) {
            moviesCollectionView.reloadItems(at: [indexPath])
        }
    }
}
