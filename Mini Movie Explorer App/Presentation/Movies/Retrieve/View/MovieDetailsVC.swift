//
//  MovieDetailsVC.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 18/06/2025.
//

import UIKit
import Kingfisher

class MovieDetailsVC: UIViewController {

    var movieId: Int!
    private var viewModel: MovieDetailsViewModel!

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MovieDetailsVC", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var taglineLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var countriesLbl: UILabel!
    @IBOutlet weak var companiesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsView.layer.cornerRadius = 24
        loadMovieDetails()
    }
    
    private func loadMovieDetails() {
        
        displayAnimatedActivityIndicatorView()
        
        Task {
            await viewModel.loadDetails(for: viewModel.movieID)
            updateUI()
        }
    }
    
    private func updateUI() {
        guard let details = viewModel.movieDetails else { return }

        hideAnimatedActivityIndicatorView()
        
        titleLbl.text = details.title
        taglineLbl.text = details.tagline
        ratingLbl.text = String(format: "%.1f", details.voteAverage)
        durationLbl.text = "\(details.runtime) min"
        releaseDateLbl.text = details.releaseDate
        genresLbl.text = details.genres.map { $0.name }.joined(separator: ", ")
        overviewLbl.text = details.overview
        statusLbl.text = details.status
        countriesLbl.text = details.productionCountries.map { $0.name }.joined(separator: ", ")
        companiesLbl.text = details.productionCompanies.map { $0.name }.joined(separator: ", ")
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(details.backdropPath)") {
            movieImg.kf.setImage(with: url)
        }
    }
}
