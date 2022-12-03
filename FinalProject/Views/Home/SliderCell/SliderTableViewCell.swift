//
//  SliderTableViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import UIKit
import SVProgressHUD

protocol SliderTableViewCellDelegate: AnyObject {
    func cell(_ cell: SliderTableViewCell, needPerform action: SliderTableViewCell.Action)
}

final class SliderTableViewCell: UITableViewCell {

    enum Action {
        case collectionCellDidTapped(data: Slider)
    }

    // MARK: - IBOutlets
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var pageControl: UIPageControl!

    // MARK: - Properties
    var delegate: SliderTableViewCellDelegate?
    private var timer: Timer?
    private var currentIndex = 0
    var viewModel: SliderTableCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
        pageControl.numberOfPages = Define.numberOfPages
        pageControl.alpha = Define.alpha
        startTimer()
    }

    // MARK: - Private functions
    private func configCollectionView() {
        let nib = UINib(nibName: Define.sliderCollectionCell, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: Define.sliderCollectionCell)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func updateCell() {
        collectionView.reloadData()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }

    // MARK: - objc functions
    @objc private func moveToNextIndex() {
        if collectionView.numberOfItems(inSection: 0) < Define.numberOfPages {
            return
        }
        if currentIndex < Define.maxIndex {
            currentIndex += 1
        } else {
            currentIndex = 0
        }

        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentIndex
    }
}

extension SliderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Define.sliderCollectionCell, for: indexPath) as? SliderCollectionViewCell,
              let viewModel = viewModel else { return UICollectionViewCell() }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SizeWithScreen.shared.width, height: self.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
              let item = viewModel.getItemFor(indexPath: indexPath),
              let delegate = delegate else { return }
        delegate.cell(self, needPerform: Action.collectionCellDidTapped(data: item))
    }
}

// MARK: - Define
extension SliderTableViewCell {
    struct Define {
        static let sliderCollectionCell: String = "SliderCollectionViewCell"
        static let numberOfPages: Int = 10
        static let alpha: CGFloat = 1
        static let maxIndex: Int = 9
    }
}
