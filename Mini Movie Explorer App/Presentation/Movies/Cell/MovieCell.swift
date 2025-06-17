//
//  MovieCell.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import UIKit
import Kingfisher

protocol MovieCellDelegate: AnyObject {
    func movieCell(_ cell: MovieCell, didTapFavoriteFor movie: Movie)
}

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var delegate: MovieCellDelegate?
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            movieTitle.text = movie.title

            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                loadingIndicator.startAnimating()
                movieImg.kf.setImage(with: url) { [weak self] _ in
                    self?.loadingIndicator.stopAnimating()
                }
            } else {
                movieImg.image = UIImage(systemName: "film")
                loadingIndicator.stopAnimating()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        movieImg.layer.cornerRadius = 8
        favoriteBtn.layer.cornerRadius = 16
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImg.image = nil
        loadingIndicator.stopAnimating()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let movie = movie else { return }

        UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)

        delegate?.movieCell(self, didTapFavoriteFor: movie)
    }
}
