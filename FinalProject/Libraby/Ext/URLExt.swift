//
//  URLExt.swift
//  FinalProject
//
//  Created by tu.le2 on 08/08/2022.
//

import Foundation

extension URL {

    func appending(_ queryItems: [URLQueryItem]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }

        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            return URL(fileURLWithPath: "")
        }
        return url
    }
}
