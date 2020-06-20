//
//  FeaturedViewModel.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

final class FeaturedViewModel: BaseViewModel {
    
    enum Error: Swift.Error, LocalizedError {
        case perPageIsNotInt
        case someImpossible
        
        var errorDescription: String? {
            switch self {
            case .perPageIsNotInt: return "per page is not Integer, maybe you pasted it."
            case .someImpossible: return "impossible error"
            }
        }
        
    }

    // Stream
    private let contentTextRelay = PublishRelay<String>()
    private let perPageRelay = PublishRelay<String>()
    
    // Property
    var buttonEnable: Driver<Bool> {
        Observable.combineLatest(contentTextRelay.asObservable(), perPageRelay.asObservable())
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .asDriver(onErrorJustReturn: false)
            .startWith(false)
    }
    
    private var request = SearchRequest()

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
    
    func didTapSearchButton(text: String?, perPage: String?) -> Observable<Result<(String, String), Error>> {
        return .create { observer in
            
            let end: () -> Disposable = { Disposables.create() }
            
            guard let text = text, let perPage = perPage else {
                observer.onNext(.failure(Error.someImpossible))
                return end()
            }
            
            if Int(perPage) == nil {
                observer.onNext(.failure(Error.perPageIsNotInt))
                return end()
            }
            observer.onNext(.success((text, perPage)))
            return end()
        }
        
    }
}
