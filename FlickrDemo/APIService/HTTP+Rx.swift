//
//  File.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/20.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

#if canImport(RxSwift)
import RxSwift

extension HTTPClient: ReactiveCompatible { }

extension Reactive where Base == HTTPClient {
    
    func send<Req: HTTPRequest>(
        _ request: Req,
        decisions: [HTTPDecision]? = nil,
        plugins: [HTTPPlugin]? = nil,
        progress: @escaping ((Progress) -> Void) = { _ in }
    ) -> Single<Req.Response> {
        
        Single.create { [weak base] single in
            
            let cancelToken = base?.send(
                request,
                decisions: decisions,
                plugins: plugins,
                progress: progress) { result in
                    switch result {
                    case .success(let data):
                        single(.success(data))
                    case .failure(let error):
                        single(.error(error))
                    }
            }
            return Disposables.create {
                cancelToken?.cancel()
            }
        }
    }
}

#endif
