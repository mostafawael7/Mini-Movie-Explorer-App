//
//  MovieCell.swift
//  Mini Movie Explorer App
//
//  Created by Mostafa Hendawi on 17/06/2025.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        movieImg.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImg.image = nil
        loadingIndicator.stopAnimating()
    }
}
