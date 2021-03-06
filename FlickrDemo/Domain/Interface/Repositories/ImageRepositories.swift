//
//  ImageRepositories.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/20.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Kingfisher

struct FavoriteModel: ResultCellModelProtocol {
    let title: String
    let fileURL: URL?
    var imageConfigurator: ((UIImageView) -> DownloadTask?)?
    
    init(url: URL) {
        if let title = url.pathComponents.last?.replacingOccurrences(of: ".jpg", with: "") {
            self.title = title.base64Decoded() ?? "Base64 decoded failure."
        } else {
            self.title = "unknown"
        }
        
        self.fileURL = url
        
        self.imageConfigurator = { imageView in
            imageView.image = UIImage(contentsOfFile: url.path)
            return nil
        }
    }
}


protocol ImageRepository: class {
    func fetchImageList(index: String) -> Single<[ResultCellModelProtocol]>
}

final class RemoteImageRepository: ImageRepository {
    
    var client: HTTPClient
    var index: String = "1"
    
    private var text: String
    private var perPage: String
    
    init(client: HTTPClient, text: String, perPage: String) {
        self.client = client
        self.text = text
        self.perPage = perPage
    }

    func fetchImageList(index: String) -> Single<[ResultCellModelProtocol]> {
        let request = SearchRequest(text: text, perPage: perPage, index: index)
        return client.rx.send(request)
            .map { $0.photos.photo }
    }
}

final class LocalImageRepository: ImageRepository {
    
    func fetchImageList(index: String = "") -> Single<[ResultCellModelProtocol]> {
        
        Single.create { single in
            
            let manager = FileManager.default
            let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            do {
                let fileURLs = try manager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                let datas = fileURLs
                    .filter { $0.pathExtension == "jpg" }
                    .map { FavoriteModel(url: $0) }
                single(.success(datas))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        
    }
}
