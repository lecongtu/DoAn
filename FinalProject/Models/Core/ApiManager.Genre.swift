//
//  ApiManager.Explore.swift
//  FinalProject
//
//  Created by tu.le2 on 14/08/2022.
//

import Foundation

extension ApiManager.Genre {
    static let explorePath: String = ApiManager.Path.baseURL + ApiManager.Path.version + ApiManager.Path.genrePath

    static func getURL() -> URL {
        let url = URL(string: explorePath)
        guard let url = url else {
            return URL(fileURLWithPath: "")
        }

        return url.appending([
            URLQueryItem(name: "api_key", value: ApiManager.Path.apiKey)
        ])
    }

    static func getGenreApi(url: URL, completion: @escaping Completion<[Genres]>) {
        ApiManager.shared.request(method: .get, with: url) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    var genres: [Genres] = []
                    if let items = data["genres"] as? [JSObject] {
                        for genre in items {
                            genres.append(Genres(json: genre, isSelect: false))
                        }
                    }
                    completion(.success(genres))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
