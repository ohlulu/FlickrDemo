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
    var dataSource = [SearchResponse.Photos.Photo]()//(0...10).map { _ in "" }
    
    private var request = SearchRequest()

    // life cycle
    init(text: String, perPage: String) {
        request.perPage = perPage
        request.text = text
        super.init()
    }
}

// MARK: - LoadNextable

extension ResultViewModel: LoadNextable {
    
    func performLoad(lastIndex: Int, success: @escaping (_ model: [SearchResponse.Photos.Photo]) -> Void) {
        let nextIndex = lastIndex + 1
        request.index = "\(nextIndex)"
        Client.send(request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                if model.stat != "ok" {
                    self.failureRelay.accept("state is \(model.stat)")
                    return
                }
                
                success(model.photos.photo)
                
            case .failure(let error):
                self.failureRelay.accept("\(error)")
            }
        }
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
                break
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
