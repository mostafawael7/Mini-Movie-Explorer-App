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
    
    weak var delegate: MovieCellDelegate?
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            movieTitle.text = movie.title

            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                movieImg.kf.setImage(with: url, placeholder: UIImage(systemName: "film"))
            } else {
                movieImg.image = UIImage(systemName: "film")
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
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print("tapped")
        guard let movie = movie else { return }
        delegate?.movieCell(self, didTapFavoriteFor: movie)
    }
}
