//
//  SearchRequest.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct SearchRequest: HTTPRequest {
    
    var tag: String { "👉 flickr.photos.search"}
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
        defaultAdapters + [
            QueryItemAdapter(parameters: parameters)
        ]
    }
    
    var responseModel: SearchResponse?
}
