//
//  FeaturedViewModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

final class FeaturedViewModel: BaseViewModel {

    // Stream
    private let buttonEnableRelay = BehaviorRelay<Bool>(value: false)
    private let contentTextRelay = BehaviorRelay<String>(value: "")
    private let perPageRelay = BehaviorRelay<String>(value: "")
    
    // Property
    var buttonEnable: Driver<Bool> {
        Observable.combineLatest(contentTextRelay.asObservable(), perPageRelay.asObservable())
            .map { !$0.0.isEmpty && !$0.0.isEmpty }
            .asDriver(onErrorJustReturn: false)
    }

    // life cycle
    override init() {
        super.init()
    }
}

// MARK: - Input

extension FeaturedViewModel {

    func viewDidLoad() {

    }
    
    func contentTextDidChange(_ text: String) {
        contentTextRelay.accept(text)
    }
    
    func perPageTextDidChange(_ text: String) {
        perPageRelay.accept(text)
    }
}

// MARK: - Output

extension FeaturedViewModel {
    
}

// MARK: - Helper

private extension FeaturedViewModel {

    func featchData() {

    }
}
