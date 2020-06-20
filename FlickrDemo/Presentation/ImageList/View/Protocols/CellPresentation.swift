//
//  CellPresentation.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/20.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import Kingfisher 

protocol ResultCellModelProtocol {
    var title: String { get }
    var imageURL: URL? { get }
    var imageConfigurator: ((UIImageView) -> DownloadTask?)? { get }
}

extension ResultCellModelProtocol {
    var imageURL: URL? { nil }
}


// Search result
extension SearchResponse.Photos.Photo: ResultCellModelProtocol {
    var imageConfigurator: ((UIImageView) -> DownloadTask?)? {
        let configurator: ((UIImageView) -> DownloadTask?) = { imageView in
            guard let url = URL(string: "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret).jpg") else {
                return nil
            }
            return imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
        return configurator
    }
}
