//
//  HTTPClient+Rx.swift
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
        plugins: [HTTPPlugin]? = nil
    ) -> Single<Req.Response> {
        
        Single.create { [weak base] single in
            
            let cancelToken = base?.send(request, decisions: decisions, plugins: plugins, progress: { _ in }) { result in
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
    
    func sendWithProgress<Req: HTTPRequest>(
        _ request: Req,
        decisions: [HTTPDecision]? = nil,
        plugins: [HTTPPlugin]? = nil
    ) -> Observable<(Progress, Req.Response?)> {
        
        let progressBlock: (AnyObserver<(Progress?, Req.Response?)>) -> ((Progress) -> Void) = { observer in
            return { progress in
                observer.onNext((progress, nil))
            }
        }
        
        let response: Observable<(Progress?, Req.Response?)> = .create { [weak base] observer -> Disposable in
            let cancelToken = base?.send(request, decisions: decisions, plugins: plugins, progress: progressBlock(observer)) { result in
                switch result {
                case .success(let data):
                    observer.onNext((nil, data))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                cancelToken?.cancel()
            }
        }
        
        return response.scan((Progress(), nil)) { (last, next) in
            let progress = next.0 ?? last.0
            let model = next.1
            return (progress, model)
        }
    }
}

#endif
