//
//  UpcomingViewModel.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 04/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct UpcomingListViewModel {
    var upcomingVM: [UpcomingViewModel]
    var genresList: Genres?
    var page: Int = 0
    var totalPages: Int = 1
}

extension UpcomingListViewModel {
    init(_ moviesResponse: MoviesResponse) {
        self.upcomingVM = (moviesResponse.results ?? []).compactMap(UpcomingViewModel.init)
        self.page = moviesResponse.page ?? 0
        self.totalPages = moviesResponse.total_pages ?? 0
    }
    
    mutating func update(genres: Genres) {
        self.genresList = genres
    }
    
    mutating func add(moviesResponse: MoviesResponse) {
        //Only add new movies if It's a new page.
        if let newPage = moviesResponse.page, newPage != page {
            let newUpcomings = (moviesResponse.results ?? []).compactMap(UpcomingViewModel.init)
            self.upcomingVM.append(contentsOf: newUpcomings)
            self.page = newPage
            self.totalPages = moviesResponse.total_pages ?? 0
        }
    }
    
    mutating func removeAll() {
        self.upcomingVM.removeAll()
        self.page = 0
        self.totalPages = 1
    }
}

extension UpcomingListViewModel {
    
    func resultAt(_ index: Int) -> UpcomingViewModel {
        return self.upcomingVM[index]
    }
}

struct UpcomingViewModel {
    let result: Results

    init(_ result: Results) {
        self.result = result
    }
}

extension UpcomingViewModel {
    
    var posterUrl: Observable<String> {
        guard let posterPath = result.poster_path else {
            return Observable<String>.just("")
        }
        return Observable<String>.just(Constants().imageBaseUrl + posterPath)
    }
    
    var releaseDate: Observable<String> {
        guard let released = result.release_date else {
            return Observable<String>.just("")
        }
        return Observable<String>.just("Released: " + released)
    }
}
