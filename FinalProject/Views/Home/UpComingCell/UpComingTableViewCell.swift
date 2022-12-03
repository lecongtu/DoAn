//
//  UpComingTableViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 26/07/2022.
//

import UIKit

protocol UpComingTableViewCellDelegate: AnyObject {
    func cell(_ cell: UpComingTableViewCell, needPerform action: UpComingTableViewCell.Action)
}

final class UpComingTableViewCell: UITableViewCell {

    enum Action {
        case collectionCellDidTapped(data: Slider)
    }

    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Properties
    var delegate: UpComingTableViewCellDelegate?
    var viewModel: UpComingTableCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = Define.titleLabel
        configCollectionView()
    }

    // MARK: - Private functions
    private func configCollectionView() {
        let nib = UINib(nibName: Define.nowPlayingCollectionCell, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: Define.nowPlayingCollectionCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    private func updateCell() {
        collectionView.reloadData()
    }
}

extension UpComingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Define.nowPlayingCollectionCell, for: indexPath) as? NowPlayingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
              let item = viewModel.getItemFor(indexPath: indexPath),
              let delegate = delegate else { return }
        delegate.cell(self, needPerform: Action.collectionCellDidTapped(data: item))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Define.sizeForItemAt
    }
}

// MARK: - Define
extension UpComingTableViewCell {
    struct Define {
        static let sizeForItemAt: CGSize = CGSize(width: (SizeWithScreen.shared.width - 30) / 2, height: ((SizeWithScreen.shared.width - 30) / 2) * 0.65)
        static let nowPlayingCollectionCell: String = "NowPlayingCollectionViewCell"
        static let titleLabel: String = "Sắp chiếu"
    }
}
