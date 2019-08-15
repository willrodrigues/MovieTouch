//
//  MoviesResponse.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 03/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation
struct MoviesResponse: Codable {
    var results : [Results]?
    let page : Int?
    let total_results : Int?
    let dates : Dates?
    let total_pages : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case results = "results"
        case page = "page"
        case total_results = "total_results"
        case dates = "dates"
        case total_pages = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        total_results = try values.decodeIfPresent(Int.self, forKey: .total_results)
        dates = try values.decodeIfPresent(Dates.self, forKey: .dates)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
    }
    
    init() {
        results = []
        page = 0
        total_results = 0
        dates = nil
        total_pages = 0
    }
    
}
