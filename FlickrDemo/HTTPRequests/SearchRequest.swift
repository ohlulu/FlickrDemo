//
//  SearchRequest.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct SearchRequest: NetworkRequest {
    
    var text = ""
    var perPage = ""
    var index = ""
    private var parameters: [String: String] {
        [
            "method": "flickr.photos.search",
            "api_key": APIConfig.key,
            "text": text,
            "per_page": perPage,
            "page": index,
            "format": "json",
            "nojsoncallback": "1"
        ]
    }
    
    var adapters: [RequestAdapter] {
        print(parameters)
        return defaultAdapters + [
            QueryItemAdapter(parameters: parameters)
        ]
    }
    var responseModel: SearchResponse?
}

struct SearchResponse: Codable {
    let stat: String
    struct Photos: Codable {
        let perpage: Int
        let pages: Int
        struct Photo: Codable {
            let owner: String
            let secret: String
            let server: String
            let id: String
            let farm: Int
            let title: String
            let isfriend: Int
            let isfamily: Int
            let ispublic: Int
            
            var url: URL? { URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg") }
        }
        let photo: [Photo]
    }
    let photos: Photos
}
