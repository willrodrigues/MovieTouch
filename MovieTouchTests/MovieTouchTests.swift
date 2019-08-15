//
//  MovieTouchTests.swift
//  MovieTouchTests
//
//  Created by Willian Rafael Perez Rodrigues on 01/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import XCTest
import RxSwift
@testable import MovieTouch

class MovieTouchTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testUpcomingMoviesRequest() {
        var moviesResponse: MoviesResponse? = nil
        let expectation = self.expectation(description: "UpcomingMoviesRequest")
        if let upcomingMoviesPath = Constants().upcomingMoviesPath {
            let resource = Resource<MoviesResponse>(url: upcomingMoviesPath, queryItems: [])
            URLRequest.load(resource: resource)
                .subscribe(onNext: { upcomingResponse in
                    moviesResponse = upcomingResponse
                    expectation.fulfill()
                }).disposed(by: disposeBag)
        }
        waitForExpectations(timeout: 60.0, handler: nil)
        XCTAssertNotNil(moviesResponse, "")
        XCTAssertEqual(moviesResponse?.results?.count, 20)
    }
    
    func testSearchMoviesRequest() {
        var moviesResponse: MoviesResponse? = nil
        let expectation = self.expectation(description: "SearchMoviesRequest")
        if let searchMoviePath = Constants().searchMoviePath {
            let searchQuery = [URLQueryItem(name: "query", value: "Matrix")]
            let resource = Resource<MoviesResponse>(url: searchMoviePath, queryItems: searchQuery)
            URLRequest.load(resource: resource)
                .subscribe(onNext: { searchMovieResponse in
                    moviesResponse = searchMovieResponse
                    expectation.fulfill()
                }).disposed(by: disposeBag)
        }
        waitForExpectations(timeout: 60.0, handler: nil)
        XCTAssertNotNil(moviesResponse, "")
        XCTAssertGreaterThan(moviesResponse?.results?.count ?? 0, 0)
    }
    
    func testGenresRequest() {
        var genres: Genres? = nil
        let expectation = self.expectation(description: "GenresRequest")
        if let genreListPath = Constants().genreListPath {
            let resource = Resource<Genres>(url: genreListPath, queryItems: [])
            URLRequest.load(resource: resource)
                .retry(3)
                .subscribe(onNext: { genresResponse in
                    genres = genresResponse
                    expectation.fulfill()
                }).disposed(by: disposeBag)
        }
        waitForExpectations(timeout: 60.0, handler: nil)
        XCTAssertNotNil(genres, "")
        XCTAssertGreaterThan(genres?.genres?.count ?? 0, 0)
    }
}
