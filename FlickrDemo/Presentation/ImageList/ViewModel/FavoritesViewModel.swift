//
//  FavoritesViewModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

class FavoritesViewModel: BaseViewModel, ImageListViewModel {

    // Stream
    let failureRelay = PublishRelay<String>()
    let reloadRelay = PublishRelay<Void>()
    
    // Property
    var dataSource = [ResultCellModelProtocol]()
    let repository: LocalImageRepository
    
    // life cycle
    init(repository: LocalImageRepository) {
        self.repository = repository
        super.init()
        
        NotificationCenter.default.addObserver(BaseDownloadResponseModel.self) { [weak self] noti in
            guard let self = self else { return }
            let model = BaseDownloadResponseModel(noti)
            self.dataSource += [FavoriteModel(url: model.fileURL)]
            self.reloadRelay.accept(())
        }
    }
}

// MARK: - Input

extension FavoritesViewModel {
    
    func viewDidLoad() {
        _ = repository.fetchImageList()
            .subscribe(onSuccess: { [weak self] model in
                guard let self = self else { return }
                self.dataSource = model
                self.reloadRelay.accept(())
            })
    }
}
