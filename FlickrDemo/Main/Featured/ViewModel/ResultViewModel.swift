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
    var dataSource = [ResultCellModelProtocol]()

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
        _ = Client.rx.sendWithProgress(request)
            .subscribe(onNext: { progress, model in
                guard let model = model else {
                    print("progress -> \(progress)")
                    return
                }
                NotificationCenter.default.post(model)
            }, onError: { [weak self] error in
                self?.failureRelay.accept(error.localizedDescription)
            })
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
