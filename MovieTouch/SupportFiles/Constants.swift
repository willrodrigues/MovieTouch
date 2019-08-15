//
//  Constants.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 01/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation

struct Constants {
    let baseUrl = "https://api.themoviedb.org/3"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w342"
    let token = "1f54bd990f1cdfb230adb312546d765d"
    var upcomingMoviesPath: URL? {
        return URL(string: baseUrl + "/movie/upcoming")
    }
    
    var searchMoviePath: URL? {
        return URL(string: baseUrl + "/search/movie")
    }
    
    var genreListPath: URL? {
        return URL(string: baseUrl + "/genre/movie/list")
    }
}
