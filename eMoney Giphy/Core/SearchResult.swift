//
//  SearchResult.swift
//  eMoney Giphy
//
//  Created by Nikoloz Tatunashvili on 23.08.18.
//  Copyright © 2018 Nikoloz Tatunashvili. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let data: [GifData]?
    let pagination: Pagination?
    
    struct GifData: Codable {
        let images: Images
        
        struct Images: Codable {
            let original: ImageUrl
            let preview_gif: ImageUrl
            
            struct ImageUrl: Codable {
                let url: URL
            }
        }

    }
    
    struct Pagination: Codable {
        let total_count: Int
        let count: Int
        let offset: Int
    }

}




