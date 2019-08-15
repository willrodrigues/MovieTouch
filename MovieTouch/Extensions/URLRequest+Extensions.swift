//
//  URLRequest+Extensions.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 03/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
    let queryItems: [URLQueryItem]?
}

extension URLRequest {
    
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                var fullURL = URLComponents(url: url, resolvingAgainstBaseURL: true)
                let apiQueryItem = URLQueryItem(name: "api_key", value: Constants().token)
                fullURL?.queryItems = [apiQueryItem]
                fullURL?.queryItems?.append(contentsOf: resource.queryItems ?? [])
                guard let urlWithKey = fullURL?.url else {
                    fatalError("It was not possible to generate your URL.")
                }
                let request = URLRequest(url: urlWithKey)
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
        }.asObservable()
    }
    
}
