//
//  ImageListViewModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/20.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

protocol ImageListViewModel2: class {
    
    // Stream
    var failureRelay: PublishRelay<String> { get }
    var reloadRelay: PublishRelay<Void> { get }

    // Property
    var failure: Observable<String> { get }
    var reload: Driver<Void> { get }
    
    var dataSource: [ResultCellModelProtocol] { get }
    
    func viewDidLoad()
    
    // Remote
    func didSelectItem(at indexPath: IndexPath)
    func loadData()
}

extension ImageListViewModel2 {
    
    var failure: Observable<String> { failureRelay.asObservable() }
    var reload: Driver<Void> { reloadRelay.asDriver(onErrorJustReturn: ()) }
}

extension ImageListViewModel2 {
    
    var numberOfItemsInSection: Int { dataSource.count }
    
    func model(at indexPath: IndexPath) -> ResultCellModelProtocol {
        dataSource[indexPath.row]
    }
}

// for Remote
extension ImageListViewModel2 {
    
    func loadData() { }
    func didSelectItem(at indexPath: IndexPath) { }
}
