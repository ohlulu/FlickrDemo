//
//  LoadNextable.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

class NextPageStatus {
    var lastIndex: Int = 1
    var hasNextPage: Bool = true
    var isLoading = false
}

protocol LoadNextable: class {
    associatedtype Model
    var dataSource: [Model] { get set }
    var nextPageStatus: NextPageStatus { get set }
    
    func performLoad(lastIndex: Int, success: @escaping (_ model: [Model]) -> Void)
    func reloadData()
}

extension LoadNextable {
    func loadNext() {
        if !nextPageStatus.hasNextPage || nextPageStatus.isLoading {
            return
        }
        nextPageStatus.isLoading = true
        performLoad(lastIndex: nextPageStatus.lastIndex, success: { [weak self] models in
            self?.nextPageStatus.isLoading = false
            guard let self = self else { return }
            self.dataSource += models
            self.reloadData()
        })
    }
}
