//
//  ResultCellModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Kingfisher

extension SearchResponse.Photos.Photo: ResultCellModelProtocol {
    var imageConfigurator: ((UIImageView) -> Void)? {
        let configurator: ((UIImageView) -> Void) = { imageView in
            guard let url = URL(string: "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret).jpg") else {
                return
            }
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        }
        return configurator
    }
}
