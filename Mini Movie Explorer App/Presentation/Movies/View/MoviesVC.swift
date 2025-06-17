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
//        moviesCollectionView.prefetchDataSource = self

        Task {
            await viewModel.loadInitialMovies()
            moviesCollectionView.reloadData()
        }
    }
}

extension MoviesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if let movie = viewModel.movie(at: indexPath.item) {
            cell.movie = movie
        }
        return cell
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
