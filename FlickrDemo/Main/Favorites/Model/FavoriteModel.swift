//
//  FavoriteModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct FavoriteModel: ResultCellModelProtocol {
    let title: String
    let fileURL: URL?
    var imageConfigurator: ((UIImageView) -> Void)?
    
    init(url: URL) {
        if let title = url.pathComponents.last?.replacingOccurrences(of: ".jpg", with: "") {
            self.title = title.base64Decoded() ?? "Base64 decoded failure."
        } else {
            self.title = "unknown"
        }
        
        self.fileURL = url
        
        self.imageConfigurator = { imageView in
            imageView.image = UIImage(contentsOfFile: url.path)
        }
    }
}
