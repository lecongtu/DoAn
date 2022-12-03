//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 22/07/2022.
//

import Foundation

final class HomeViewModel {
    // MARK: - enum
    enum TypeCell: Int, CaseIterable {
        case slider
        case nowPlaying
        case topRated
        case latest
        case upComing

        var ratioHeightForRow: Double {
            switch self {
            case .slider:
                return 3.5
            case .nowPlaying:
                return 4.5
            case .topRated:
                return 3.5
            case .latest:
                return 1 / 0.85
            case .upComing:
                return 4.4
            }
        }

        func getURL() -> URL {
            switch self {
            case .slider:
                return ApiManager.Movie.getURL(type: .popular, typePath: ApiManager.Path.popular, movieId: nil)
            case .nowPlaying:
                return ApiManager.Movie.getURL(type: .nowPlaying, typePath: ApiManager.Path.nowPlaying, movieId: nil)
            case .topRated:
                return ApiManager.Movie.getURL(type: .topRated, typePath: ApiManager.Path.topRated, movieId: nil)
            case .latest:
                let movieId = UserDefaults.standard.integer(forKey: Session.shared.movieId)
                return ApiManager.Movie.getURL(type: .latest, typePath: ApiManager.Path.latest, movieId: movieId)
            case .upComing:
                return ApiManager.Movie.getURL(type: .upComing, typePath: ApiManager.Path.upComing, movieId: nil)
            }
        }
    }

    private(set) var data: [TypeCell: [Slider]] = [:]

    // MARK: - Public functions
    func numberOfRowInSection() -> Int {
        return TypeCell.allCases.count
    }

    func viewModelForItem(type: TypeCell) -> (Any) {
        switch type {
        case .slider:
            return (SliderTableCellViewModel(sliders: data[type] ?? []))
        case .nowPlaying:
            return (NowPlayingTableCellViewModel(nowPlayings: data[type] ?? []))
        case .topRated:
            return (TopRatedTableCellViewModel(topRated: data[type] ?? []))
        case .latest:
            return (LatestTableCellViewModel(latest: data[type] ?? []))
        case .upComing:
            return (UpComingTableCellViewModel(upComings: data[type] ?? []))
        }
    }

    func getHomeApi(typeCell: TypeCell, completion: @escaping Completion<[Slider]>) {
        ApiManager.Movie.getHomeApi(url: typeCell.getURL()) {[weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let data):
                this.data[typeCell] = data
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func heightForRowAt(at indexPath: IndexPath) -> Double {
        guard let type = TypeCell(rawValue: indexPath.row) else {
            return 0
        }

        return type.ratioHeightForRow
    }

    func viewModelForDetail(detail: Slider) -> DetailViewModel {
        return DetailViewModel(detail: detail)
    }
}
