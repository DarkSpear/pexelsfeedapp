//
//  PexelsImage.swift
//  pexelsfeed
//
//  Created by Andrey Chipilenko on 13.08.2023.
//

import Foundation

struct PexelsImage: Identifiable, Decodable {
    var id: Int
    var url: String
    var photographer: String
    var width: Int
    var height: Int
    var photographerId: Int
    var color: String
    var src: SrcImage

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case photographer
        case width
        case height
        case photographerId = "photographer_id"
        case color = "avg_color"
        case src
    }
}

struct SrcImage: Decodable {
    var original: String
    var large2x: String
    var large: String
    var medium: String
    var small: String
    var portrait: String
    var landscape: String
    var tiny: String
}

struct PexelsAPIResponse: Decodable {
    var photos: [PexelsImage]
    var page: Int
    var perPage: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case photos
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
    }
}
