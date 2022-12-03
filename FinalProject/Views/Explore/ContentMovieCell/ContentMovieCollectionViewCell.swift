//
//  ContentMovieCollectionViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 10/08/2022.
//

import UIKit

final class ContentMovieCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - Properties
    var viewModel: ContentMovieCollectionCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Private functions
    private func configUI() {
        imageView.layer.cornerRadius = Define.cornerRadius
    }

    private func updateCell() {
        guard let viewModel = viewModel,
              let rating = viewModel.contentMovieSlider?.voteAverage else {
            return
        }

        ratingLabel.text = "\(String(describing: rating))"
        titleLabel.text = viewModel.contentMovieSlider?.originalTitle
        if let image = viewModel.contentMovieSlider?.image {
            imageView.image = image
        } else {
            imageView.downloadImage(url: ApiManager.Path.imageURL + ((viewModel.contentMovieSlider?.backdropPath).content)) { image in
                if let image = image {
                    viewModel.contentMovieSlider?.image = image
                    self.imageView.image = image
                } else {
                    self.imageView.image = nil
                }
            }
        }
    }
}

// MARK: - Define
extension ContentMovieCollectionViewCell {
    struct Define {
        static let cornerRadius: CGFloat = 10
    }
}
