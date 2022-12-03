//
//  ApiManager.Search.swift
//  FinalProject
//
//  Created by tu.le2 on 08/08/2022.
//

import Foundation

extension ApiManager.Search {
    static let searchPath: String = ApiManager.Path.baseURL + ApiManager.Path.version + ApiManager.Path.searchPath + ApiManager.Path.moviePath

    static func getURL(query: String) -> URL {
        let url = URL(string: searchPath)
        guard let url = url else {
            return URL(fileURLWithPath: "")
        }

        return url.appending([
            URLQueryItem(name: "api_key", value: ApiManager.Path.apiKey),
            URLQueryItem(name: "query", value: query)
        ])
    }

    static func getSearchURL(url: URL, completion: @escaping Completion<[Slider]>) {
        ApiManager.shared.request(method: .get, with: url) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    var searchs: [Slider] = []
                    if let items = data["results"] as? [JSObject] {
                        for search in items {
                            searchs.append(Slider(json: search))
                        }
                    }
                    completion(.success(searchs))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
