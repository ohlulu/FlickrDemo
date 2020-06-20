//
//  SearchResponseModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/20.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let stat: String
    struct Photos: Codable {
        let perpage: Int
        let pages: Int
        let total: String
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

            var imageURL: URL? {
                URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
            }
        }
        let photo: [Photo]
    }
    let photos: Photos
}

