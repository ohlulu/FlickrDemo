//
//  ResultViewModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

final class ResultViewModel: BaseViewModel {

    // Stream
    private let failureRelay = PublishRelay<String>()
    private let reloadRelay = PublishRelay<Void>()

    // Property
    var failure: Observable<String> { failureRelay.asObservable() }
    var reload: Driver<Void> { reloadRelay.asDriver(onErrorJustReturn: ()) }
    
    var nextPageStatus: NextPageStatus = NextPageStatus()
    var dataSource = [ResultCellModelProtocol]()//(0...10).map { _ in "" }
    
//    private var request = SearchRequest()

    private let repository: ImageRepository
    // life cycle
    init(repository: ImageRepository) {
        self.repository = repository

        super.init()
    }
}

// MARK: - LoadNextable

extension ResultViewModel: LoadNextable {
    
    func performLoad(lastIndex: Int, success: @escaping (_ model: [ResultCellModelProtocol]) -> Void) {
        
        let nextIndex = lastIndex + 1
        nextPageStatus.lastIndex = nextIndex
        _ = repository.fetchImageList(index: "\(nextIndex)")
            .subscribe(onSuccess: { [weak self] result in
                if !result.isEmpty {
                    success(result)
                } else {
                    self?.failureRelay.accept("No result.")
                }
            }, onError: { error in
                self.failureRelay.accept("\(error)")
            })
    }
    
    func reloadData() {
        reloadRelay.accept(())
    }
}

// MARK: - Input

extension ResultViewModel {
    
    func didSelectItem(at indexPath: IndexPath) {
        
        let data = dataSource[indexPath.row]
        
        guard let url = data.imageURL else {
            failureRelay.accept("url is nil.")
            return
        }
        
        let request = DownloadImageRequest(url: url, title: data.title)
        Client.send(request) { [weak self] result in
            switch result {
            case .success(let model):
                NotificationCenter.default.post(model)
            case .failure(let error):
                self?.failureRelay.accept(error.localizedDescription)
            }
        }
    }
}

// MARK: - Output

extension ResultViewModel {
    
    var numberOfItemsInSection: Int { dataSource.count }
    
    func model(at indexPath: IndexPath) -> ResultCellModelProtocol {
        dataSource[indexPath.row]
    }
}

// MARK: - Helper

private extension ResultViewModel {

}
