//
//  HomeViewController.swift
//  FinalProject
//
//  Created by An Nguyen Q. VN.Danang on 08/06/2022.
//

import UIKit
import SVProgressHUD

final class HomeViewController: UIViewController {

    // MARK: - enum
    enum TypeCell: Int {
        case slider
        case nowPlaying
        case topRated
        case latest
        case upComing

        var deque: String {
            switch self {
            case .slider:
                return "SliderTableViewCell"
            case .nowPlaying:
                return "NowPlayingTableViewCell"
            case .topRated:
                return "TopRatedTableViewCell"
            case .latest:
                return "LatestTableViewCell"
            case .upComing:
                return "UpComingTableViewCell"
            }
        }
    }

    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!

    // MARK: - Properties
    var viewModel: HomeViewModel?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        callAllApi()
    }

    // MARK: - Private functions
    private func configUI() {
        configNavigationBar()
        configTableView()
    }

    private func callAllApi() {
        guard let viewModel = viewModel else {
            return
        }
        var isError: Bool = false
        var message: String?

        let dispatchGroup = DispatchGroup()
        SVProgressHUD.show()

        dispatchGroup.enter()
        viewModel.getHomeApi(typeCell: .slider) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard !isError, message.content.isEmpty else { break }
                isError = true
                message = error.localizedDescription.description
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        viewModel.getHomeApi(typeCell: .nowPlaying) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard !isError, message.content.isEmpty else { break }
                isError = true
                message = error.localizedDescription.description
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        viewModel.getHomeApi(typeCell: .topRated) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard !isError, message.content.isEmpty else { break }
                isError = true
                message = error.localizedDescription.description
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        viewModel.getHomeApi(typeCell: .latest) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard !isError else { break }
                guard !isError, message.content.isEmpty else { break }
                isError = true
                message = error.localizedDescription.description
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        viewModel.getHomeApi(typeCell: .upComing) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                guard !isError, message.content.isEmpty else { break }
                isError = true
                message = error.localizedDescription.description
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            SVProgressHUD.dismiss {
                if isError {
                    self.showErrorDialog(message: message.content) {
                        self.dismiss(animated: true)
                    }
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func configNavigationBar() {
        let logoImageView: UIImageView = UIImageView(image: UIImage(named: Define.nameImage))
        logoImageView.frame = Define.frameLogoImageView
        logoImageView.contentMode = Define.contentMode
        let imageItem = UIBarButtonItem(customView: logoImageView)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = Define.widthBarButtonItem
        navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]

        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: SizeWithScreen.shared.width * 3 / 4, height: 20))
        let searchButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: SizeWithScreen.shared.width * 3 / 4, height: 40))
        searchButton.addTarget(self, action: #selector(searchButtonTouchUpInside), for: .touchUpInside)
        searchBar.addSubview(searchButton)
        searchBar.placeholder = Define.searchBarPlaceholder
        let logoNavBar = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = logoNavBar
    }

    private func configTableView() {
        configNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.bounces = false
    }

    private func configNib() {
        let sliderCellNib = UINib(nibName: Define.sliderTableCell, bundle: .main)
        tableView.register(sliderCellNib, forCellReuseIdentifier: Define.sliderTableCell)
        let nowPlayingCellNib = UINib(nibName: Define.nowPlayingTableCell, bundle: .main)
        tableView.register(nowPlayingCellNib, forCellReuseIdentifier: Define.nowPlayingTableCell)
        let topRatedCellNib = UINib(nibName: Define.topRatedTableCell, bundle: .main)
        tableView.register(topRatedCellNib, forCellReuseIdentifier: Define.topRatedTableCell)
        let latestCellNib = UINib(nibName: Define.latestTableCell, bundle: .main)
        tableView.register(latestCellNib, forCellReuseIdentifier: Define.latestTableCell)
        let upComingCellNib = UINib(nibName: Define.upComingTableViewCell, bundle: .main)
        tableView.register(upComingCellNib, forCellReuseIdentifier: Define.upComingTableViewCell)
    }

    private func pushDetailVC(detail: Slider) {
        guard let viewModel = viewModel else {
            return
        }
        let detailVC = DetailViewController()
        detailVC.viewModel = viewModel.viewModelForDetail(detail: detail)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - objc functions
    @objc private func searchButtonTouchUpInside() {
        let searchVC = SearchViewController()
        searchVC.viewModel = SearchViewModel()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - Datasource,Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel,
              let type = TypeCell(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: type.deque, for: indexPath)
        switch type {
        case .slider:
            guard let cell = cell as? SliderTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(type: .slider) as? SliderTableCellViewModel
        case .nowPlaying:
            guard let cell = cell as? NowPlayingTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(type: .nowPlaying) as? NowPlayingTableCellViewModel
        case .topRated:
            guard let cell = cell as? TopRatedTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(type: .topRated) as? TopRatedTableCellViewModel
        case .latest:
            guard let cell = cell as? LatestTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(type: .latest) as? LatestTableCellViewModel
        case .upComing:
            guard let cell = cell as? UpComingTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.viewModel = viewModel.viewModelForItem(type: .upComing) as? UpComingTableCellViewModel
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else {
            return 0
        }

        return SizeWithScreen.shared.height / CGFloat(viewModel.heightForRowAt(at: indexPath))
    }
}

extension HomeViewController: SliderTableViewCellDelegate {
    func cell(_ cell: SliderTableViewCell, needPerform action: SliderTableViewCell.Action) {
        switch action {
        case .collectionCellDidTapped(let detail):
            pushDetailVC(detail: detail)
        }
    }
}

extension HomeViewController: NowPlayingTableViewCellDelegate {
    func cell(_ cell: NowPlayingTableViewCell, needPerform action: NowPlayingTableViewCell.Action) {
        switch action {
        case .collectionCellDidTapped(let detail):
            pushDetailVC(detail: detail)
        }
    }
}

extension HomeViewController: TopRatedTableViewCellDelegate {
    func cell(_ cell: TopRatedTableViewCell, needPerform action: TopRatedTableViewCell.Action) {
        switch action {
        case .collectionCellDidTapped(let detail):
            pushDetailVC(detail: detail)
        }
    }
}

extension HomeViewController: LatestTableViewCellDelegate {
    func cell(_ cell: LatestTableViewCell, needPerform action: LatestTableViewCell.Action) {
        switch action {
        case .collectionCellDidTapped(let detail):
            pushDetailVC(detail: detail)
        }
    }
}

extension HomeViewController: UpComingTableViewCellDelegate {
    func cell(_ cell: UpComingTableViewCell, needPerform action: UpComingTableViewCell.Action) {
        switch action {
        case .collectionCellDidTapped(let detail):
            pushDetailVC(detail: detail)
        }
    }
}

// MARK: - Define
extension HomeViewController {
    struct Define {
        static let sliderTableCell: String = "SliderTableViewCell"
        static let nowPlayingTableCell: String = "NowPlayingTableViewCell"
        static let topRatedTableCell: String = "TopRatedTableViewCell"
        static let latestTableCell: String = "LatestTableViewCell"
        static let upComingTableViewCell: String = "UpComingTableViewCell"
        static let nameImage: String = "logo"

        static let widthBarButtonItem: CGFloat = -25
        static let contentMode: UIView.ContentMode = .scaleAspectFill
        static let searchBarPlaceholder: String = "Tìm kiếm"
        static let frameLogoImageView: CGRect = CGRect(x: 0, y: 0, width: 150, height: 25)
    }
}
