//
//  Genres.swift
//  MovieTouch
//
//  Created by Willian Rafael Perez Rodrigues on 06/07/19.
//  Copyright © 2019 Will Rodrigues. All rights reserved.
//

import Foundation

struct Genres : Codable {
    let genres : [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        genres = try values.decodeIfPresent([Genre].self, forKey: .genres)
    }
    
    init() {
        genres = []
    }
}

struct Genre : Codable {
    let id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}
