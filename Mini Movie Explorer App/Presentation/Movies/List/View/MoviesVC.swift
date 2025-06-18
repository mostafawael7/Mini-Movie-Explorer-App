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
    private var repo: MovieRepository!

    fileprivate let cellID = "MovieCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Popular Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let apiClient = DefaultAPIClient()
        let service = TMDBService(apiClient: apiClient)
        repo = MovieRepositoryImpl(service: service)
        let useCase = GetMoviesUseCase(repository: repo)
        viewModel = MoviesViewModel(getMoviesUseCase: useCase)

        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        moviesCollectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieCell
        if let movie = viewModel.movie(at: indexPath.item) {
            cell.movie = movie
            cell.delegate = self
            let imageName = FavoritesManager.shared.isFavorite(id: movie.id) ? "heart.fill" : "heart"
            cell.favoriteBtn.setImage(UIImage(systemName: imageName), for: .normal)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = viewModel.movie(at: indexPath.item) {
            let useCase = GetMovieDetailsUseCase(repository: repo)
            let detailsVM = MovieDetailsViewModel(
                movieID: movie.id,
                useCase: useCase
            )
            let detailsVC = MovieDetailsVC(viewModel: detailsVM)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = viewModel.numberOfMovies - 1
        if indexPath.item == lastItem {
            Task {
                await viewModel.loadNextPageIfNeeded(currentIndex: indexPath.item)
                collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: 300)
    }
}

extension MoviesVC: MovieCellDelegate {
    func movieCell(_ cell: MovieCell, didTapFavoriteFor movie: Movie) {
        
        FavoritesManager.shared.toggleFavorite(id: movie.id)
        
        if let indexPath = moviesCollectionView.indexPath(for: cell) {
            moviesCollectionView.reloadItems(at: [indexPath])
        }
    }
}
