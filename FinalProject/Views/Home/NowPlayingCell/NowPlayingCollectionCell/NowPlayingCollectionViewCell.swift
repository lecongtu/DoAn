//
//  NowPlayingCollectionViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import UIKit

final class NowPlayingCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - Properties
    var viewModel: NowPlayingCollectionCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Override functions
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = Define.cornerRadius
    }

    // MARK: - Private functions
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else {
            return
        }
        titleLabel.text = viewModel.slider?.originalTitle
        if let imgURL = viewModel.slider?.backdropPath {
            imageView.downloadImage(url: ApiManager.Path.imageURL + imgURL)
        }
    }
}

// MARK: - Define
extension NowPlayingCollectionViewCell {
    struct Define {
        static let cornerRadius: CGFloat = 10
    }
}
