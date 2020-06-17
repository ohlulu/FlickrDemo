//
//  FavoritesViewModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

final class FavoritesViewModel: BaseViewModel {

    // Stream
    private let reloadRelay = PublishRelay<Void>()
    
    // Property
    var reload: Driver<Void> { reloadRelay.asDriver(onErrorJustReturn: ()) }
    
    var dataSource = [FavoriteModel]()

    // life cycle
    override init() {
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
        let manager = FileManager.default
        let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let fileURLs = try? manager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else {
            return
        }
        dataSource = fileURLs
            .filter { $0.pathExtension == "jpg" }
            .map { FavoriteModel(url: $0) }
        reloadRelay.accept(())
    }
}

// MARK: - Output

extension FavoritesViewModel {
    
    var numberOfItemsInSection: Int { dataSource.count }
    
    func model(at indexPath: IndexPath) -> ResultCellModelProtocol {
        dataSource[indexPath.row]
    }
}

// MARK: - Helper

private extension FavoritesViewModel {

    func featchData() {

    }
}
