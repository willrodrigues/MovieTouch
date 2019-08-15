//
//  MovieDetailsViewModel.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 05/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieDetailsViewModel {
    let result: Results
    var genres: Genres?
    
    init(_ result: Results, genres: Genres?) {
        self.result = result
        self.genres = genres
    }
}

extension MovieDetailsViewModel {
    
    var title: Observable<String> {
        return Observable<String>.just(result.title ?? "-")
    }
    
    var genre: Observable<[Int]> {
        return Observable<[Int]>.just(result.genre_ids ?? [])
    }
    
    var genreValues: Observable<String> {
        var genresValue: [String] = []
        result.genre_ids?.forEach { genreID in
            let genreName = genres?.genres?.first(where: {$0.id == genreID})?.name ?? ""
            genresValue.append(genreName)
        }
        if genresValue.count > 0 {
            return Observable<String>.just("Genres: " + genresValue.joined(separator: ", "))
        } else {
            return Observable<String>.just("Genres: Not Specified")
        }
    }
    
    var releaseDate: Observable<String> {
        guard let released = result.release_date else {
            return Observable<String>.just("")
        }
        return Observable<String>.just("Released: " + released)
    }
    
    var overview: Observable<String> {
        return Observable<String>.just(result.overview ?? "")
    }
    
    var posterUrl: Observable<String> {
        guard let posterPath = result.poster_path else {
            return Observable<String>.just("")
        }
        return Observable<String>.just(Constants().imageBaseUrl + posterPath)
    }
    
}
