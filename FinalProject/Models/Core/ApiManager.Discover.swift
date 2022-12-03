//
//  ApiManager.Discover.swift
//  FinalProject
//
//  Created by tu.le2 on 12/08/2022.
//

import Foundation

extension ApiManager.Discover {

    static let searchPath: String = ApiManager.Path.baseURL + ApiManager.Path.version + ApiManager.Path.discoverPath + ApiManager.Path.moviePath

    static func getURL(keys: [Int], page: Int) -> URL {
        var queryString: String = ""
        let url = URL(string: searchPath)
        guard let url = url else {
            return URL(fileURLWithPath: "")
        }

        for key in keys {
            if key == keys.first {
                queryString += "\(key)"
            } else {
                queryString += ",\(key)"
            }
        }

        return url.appending([
            URLQueryItem(name: "api_key", value: ApiManager.Path.apiKey),
            URLQueryItem(name: "with_genres", value: queryString),
            URLQueryItem(name: "page", value: "\(String(describing: page))")
        ])
    }

    static func getExploreApi(url: URL, completion: @escaping Completion<[Slider]>) {
        ApiManager.shared.request(method: .get, with: url) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    var contentMovies: [Slider] = []
                    if let items = data["results"] as? [JSObject] {
                        for contentMovie in items {
                            contentMovies.append(Slider(json: contentMovie))
                        }
                    }
                    completion(.success(contentMovies))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
