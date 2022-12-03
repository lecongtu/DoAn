//
//  DetailViewController.swift
//  FinalProject
//
//  Created by tu.le2 on 17/08/2022.
//

import UIKit
import youtube_ios_player_helper

final class DetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var playerView: YTPlayerView!
    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: DetailViewModel?
    private var pageNumber: Int = 1

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func callApi() {
        let dispatchGroup = DispatchGroup()

        guard let viewModel = viewModel else {
            return
        }
        dispatchGroup.enter()

        getVideosApi(movieId: viewModel.id) {

            dispatchGroup.leave()
        }

        dispatchGroup.enter()

        viewModel.getDetailApi(movieId: viewModel.id, pageNumber: pageNumber, completion: { _ in

            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }

    private func getVideosApi(movieId: Int, completion: @escaping (() -> Void)) {
        guard let viewModel = viewModel else { return }
        viewModel.getVideosApi(movieId: movieId) {[weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.playerView.load(withVideoId: (viewModel.videoKey?.key).content, playerVars: ["playsinline": "1"])
                this.playerView.delegate = this
                this.playerView.webView?.backgroundColor = Define.ytBackgroundColor
                this.playerView.webView?.isOpaque = false
                completion()
            case .failure:
                completion()
            }
        }
    }

    // MARK: - Private functions
    private func configUI() {
        playerView.delegate = self
        playerView.webView?.backgroundColor = Define.ytBackgroundColor
        playerView.webView?.isOpaque = false
        configNavigationBar()
        callApi()
        configCollectionView()
        tabBarController?.tabBar.isHidden = true
    }

    private func configCollectionView() {
        configNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func configNib() {
        let headerNib = UINib(nibName: Define.headerNib, bundle: .main)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Define.headerNib)
        let cellNib = UINib(nibName: Define.cellNib, bundle: .main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Define.cellNib)
    }

    private func configNavigationBar() {
        let backButton = UIButton()
        if #available(iOS 13.0, *) {
            backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        }
        backButton.tintColor = Define.backButtonTintColor
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let leftItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftItem
    }

    private func loadMoreData() {
        pageNumber += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            guard let viewModel = self.viewModel else { return }
            viewModel.getDetailApi(movieId: viewModel.id, pageNumber: self.pageNumber, completion: { _ in
                self.collectionView.reloadData()
            })
        }
    }

    // MARK: - Objc functions
    @objc private func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Delegate, Datasource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Define.cellNib, for: indexPath) as? DetailCollectionViewCell,
            let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        default:
            guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Define.headerNib, for: indexPath) as? HeaderCollectionReusableView,
                  let viewModel = viewModel else {
                return UICollectionReusableView()
            }
            cell.frame = Define.frameForHeader
            cell.dataSource = self
            cell.viewModel = viewModel.viewModelForHeader()
            return cell
        }
    }
}

// MARK: - DelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return Define.sizeForHeader
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Define.sizeForItem
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.didSelectItemAt(indexPath: indexPath)
        pageNumber = 1
        viewModel.details.removeAll()
        viewDidLoad()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        if indexPath.row == viewModel.numberOfItems() - 5 {
            loadMoreData()
        }
    }
}

extension DetailViewController: HeaderCollectionReusableViewDataSource {
    func getDetail() -> (originalTitle: String, overview: String) {
        guard let viewModel = viewModel else {
            return (originalTitle: "", overview: "")
        }
        return (originalTitle: viewModel.originalTitle, overview: viewModel.overview)
    }
}

// MARK: - YTPlayerDelegate
extension DetailViewController: YTPlayerViewDelegate {
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }
}

// MARK: - Define
extension DetailViewController {
    struct Define {
        static let headerNib: String = "HeaderCollectionReusableView"
        static let cellNib: String = "DetailCollectionViewCell"
        static let frameForHeader = CGRect(x: 0, y: 0, width: SizeWithScreen.shared.width, height: 250)
        static let sizeForHeader = CGSize(width: SizeWithScreen.shared.width, height: 250)
        static let sizeForItem = CGSize(width: SizeWithScreen.shared.width, height: 130)
        static let backButtonTintColor: UIColor = .white
        static let ytBackgroundColor: UIColor = .black
    }
}
