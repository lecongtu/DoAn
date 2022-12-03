//
//  SearchViewController.swift
//  FinalProject
//
//  Created by tu.le2 on 22/08/2022.
//

import UIKit
import RealmSwift

final class SearchViewController: UIViewController {

    enum CellType {
        case content
        case suggest
    }

    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel: SearchViewModel?
    private var searchTimer: Timer?
    private var searchBar: UISearchBar = UISearchBar()
    private var tableView = UITableView()
    private var searchCell: CellType = .suggest

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        searchBar.becomeFirstResponder()
    }

    private func configUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        tap.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tap)
        configNavigationBar()
        configCollectionView()
        configTableView()
        tabBarController?.tabBar.isHidden = true
    }

    private func configNavigationBar() {
        searchBar = Define.searchBar
        searchBar.placeholder = Define.placeHolder
        searchBar.delegate = self
        let searchNavBar = UIBarButtonItem(customView: searchBar)
        navigationItem.leftBarButtonItem = searchNavBar

        let backButton: UIButton = Define.backButton
        backButton.setTitle("Huỷ bỏ", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.titleLabel?.font = Define.font
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let backNavBar = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = backNavBar
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationItem.scrollEdgeAppearance = navigationBarAppearance
        }
    }

    private func configCollectionView() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.fetchData {[weak self] isFetchData in
            guard let this = self else { return }
            if isFetchData {
                configNib()
                collectionView.contentInset = Define.contentInset
                collectionView.delegate = self
                collectionView.dataSource = self
            } else {
                showErrorDialog(message: String.Define.getValueFailFromRealm) {
                    this.navigationController?.popViewController(animated: false)
                }
            }
        }
    }

    private func configTableView() {
        tableView.frame = Define.framreSubView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Define.suggestCell)
        let nib = UINib(nibName: Define.contentSearchCell, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: Define.contentSearchCell)
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        view.addSubview(tableView)
    }

    private func configNib() {
        let headerNib = UINib(nibName: Define.headerNib, bundle: .main)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Define.headerNib)
        let cellNib = UINib(nibName: Define.cellNib, bundle: .main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: Define.cellNib)
    }

    private func loadSuggestView(query: String) {
        if #available(iOS 10.0, *) {
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                guard let this = self else { return }
                this.loadContentSearch(query: query)
            })
        } else {
            loadContentSearch(query: query)
        }
    }

    private func loadContentSearch(query: String) {
        guard let viewModel = viewModel else {
            return
        }

        viewModel.getApiSearch(query: query) { _ in
            self.tableView.reloadData()
            self.showTableView(isHidden: false)
        }
    }

    private func showTableView(isHidden: Bool) {
        tableView.isHidden = isHidden
    }

    @objc private func pop() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: true)
        searchBar.text = ""
    }

    @objc private func screenTapped() {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Define.cellNib, for: indexPath)
                as? SearchCollectionViewCell,
              let viewModel = viewModel else { return UICollectionViewCell() }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Define.headerNib, for: indexPath) as? SearchHeaderView else {
                return UICollectionReusableView()
            }
            header.delegate = self
            header.frame = Define.headerFrame
            return header
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        searchBar.text = viewModel.history[indexPath.row].originalTitle
        searchCell = .content
        loadContentSearch(query: viewModel.history[indexPath.row].originalTitle)
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return Define.sizeForHeader
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel,
              let title = viewModel.history[safe: indexPath.row] else { return CGSize(width: 0, height: 0) }
        let cellWidth = (title.originalTitle.size(withAttributes: [.font: UIFont.systemFont(ofSize: 10.0)]).width ) + 50
        return CGSize(width: cellWidth, height: 30.0)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowContentInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        switch searchCell {
        case .content:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Define.contentSearchCell, for: indexPath) as? SearchContentTableViewCell else { return UITableViewCell() }
            cell.viewModel = viewModel.viewModelForContentSearch(at: indexPath)
            return cell
        case .suggest:
            let cell = tableView.dequeueReusableCell(withIdentifier: Define.suggestCell, for: indexPath)
            cell.textLabel?.text = viewModel.getNameForSuggest(at: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchCell {
        case .content:
            guard let viewModel = viewModel else {
                return
            }
            let detailVC = DetailViewController()
            detailVC.viewModel = viewModel.viewModelForDetail(at: indexPath)
            navigationController?.pushViewController(detailVC, animated: true)
        case .suggest:
            guard let viewModel = viewModel else { return }
            searchCell = .content
            searchBar.text = viewModel.contentSearch[indexPath.row].originalTitle
            loadContentSearch(query: searchBar.text ?? "")
            viewModel.addHistory(title: viewModel.contentSearch[indexPath.row].originalTitle ?? "")
            showTableView(isHidden: false)
            searchBar.resignFirstResponder()
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch searchCell {
        case .content:
            return Define.heightContentSearchCell
        case .suggest:
            return Define.heightSuggestSearchCell
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = viewModel else { return }
        searchTimer?.invalidate()
        searchCell = .suggest
        searchText.isEmpty ? showTableView(isHidden: true) : loadSuggestView(query: searchText)
        viewModel.fetchData { isSearch in
            if isSearch {
                collectionView.reloadData()
            } else {
                showErrorDialog(message: String.Define.getValueFailFromRealm) {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel = viewModel,
              let searchString = searchBar.text else { return }
        searchCell = .content
        viewModel.addHistory(title: searchString)
        searchBar.resignFirstResponder()
        showTableView(isHidden: false)
        tableView.reloadData()
    }
}

extension SearchViewController: SearchHeaderViewDelegate {
    func view(view: SearchHeaderView, needPerForm action: SearchHeaderView.Action) {
        switch action {
        case .delete:
            guard let viewModel = viewModel else { return }
            viewModel.deleteAllHistory { isDelete in
                if isDelete {
                    viewModel.fetchData { isFetchData in
                        if isFetchData {
                            collectionView.reloadData()
                        } else {
                            showErrorDialog(message: String.Define.getValueFailFromRealm) {
                                self.dismiss(animated: true)
                            }
                        }
                    }
                } else {
                    showErrorDialog(message: String.Define.deleteValueFailFromRealm) {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
}

extension SearchViewController {
    struct Define {
        static let placeHolder: String = "Tìm kiếm"
        static let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        static let font = UIFont(name: "Helvetica", size: 15)
        static let contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        static let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: SizeWithScreen.shared.width * 3 / 4, height: 20))
        static let headerNib: String = "SearchHeaderView"
        static let cellNib: String = "SearchCollectionViewCell"
        static let suggestCell: String = "SuggestTableViewCell"
        static let contentSearchCell: String = "SearchContentTableViewCell"
        static let headerFrame = CGRect(x: 0, y: 0, width: SizeWithScreen.shared.width - 20, height: 50)
        static let tagSubView: Int = 100
        static let framreSubView = CGRect(x: 0, y: 0, width: SizeWithScreen.shared.width, height: SizeWithScreen.shared.height)
        static let heightContentSearchCell: CGFloat = 100
        static let heightSuggestSearchCell: CGFloat = 50
        static let sizeForHeader = CGSize(width: SizeWithScreen.shared.width, height: 50)
    }
}
