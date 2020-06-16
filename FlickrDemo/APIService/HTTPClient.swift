//
//  HTTPClient.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

let Client = HTTPClient.default

public struct HTTPClient {
    
    static let `default` = HTTPClient()
    
    private let session: Alamofire.Session
    
    public init(session: Alamofire.Session = .default) {
        self.session = session
    }
    
    @discardableResult
    func send<Req: NetworkRequest>(
        _ request: Req,
        decisions: [NetworkDecision]? = nil,
        plugins: [HTTPPlugin]? = nil,
        progress: @escaping ((Progress) -> Void) = { _ in },
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) -> CancelToken {
        
        var _decisions = decisions ?? request.decisions
        if !_decisions.isEmpty {
            if var first = _decisions[0] as? LogDecision {
                first.startTime = Date()
                _decisions.removeFirst()
                _decisions.insert(first, at: 0)
            }
        }
        
        let plugins = plugins ?? request.plugins
        
        plugins.forEach { $0.willSend(request) }
        
        let completion: RequestableCompletion = { response, urlRequest, data, error in
            
            plugins.forEach { $0.didReceive(request, result: (data, response, error)) }
            
            if let error = error {
                handler(.failure(error))
                return
            }
            
            guard let httpResponse = response else {
                handler(.failure(NetworkError.Response.nilResponse))
                return
            }
            
            guard let data = data else {
                handler(.failure(NetworkError.Response.nilData))
                return
            }
            
            self.handleDecision(
                request: request,
                data: data,
                response: httpResponse,
                decisions: _decisions,
                plugins: plugins,
                handler: handler
            )
        }
        
        switch request.task {
        case .normal:
            return sendNormalRequest(request, completionHandler: completion)
        case .upload(let multipartColumns):
            do {
                return try sendUploadRequest(request, multiparColumns: multipartColumns, progress: progress, completionHandler: completion)
            } catch {
                handler(.failure(error))
            }
        case .download(let destination):
            return sendDownloadRequest(request, destination: destination, progress: progress, completionHandler: completion)
        }
        
        return CancelToken()
    }

    /// DataRequest
    private func sendNormalRequest<Req: NetworkRequest>(
        _ request: Req,
        completionHandler: @escaping RequestableCompletion
    ) -> CancelToken {
        let request = session.request(request)
            .response(completionHandler: completionHandler)
        return CancelToken(request: request)
    }
    
    /// UploadRequest
    private func sendUploadRequest<Req: NetworkRequest>(
        _ request: Req,
        multiparColumns: [MultipartColumn],
        progress: @escaping ((Progress) -> Void),
        completionHandler: @escaping RequestableCompletion
    ) throws -> CancelToken {
        
        let multipartFormData = MultipartFormData()
        try multipartFormData.adapted(columns: multiparColumns)
        
        let uploadRequest = session.upload(multipartFormData: multipartFormData, with: request)
            .uploadProgress(closure: progress)
            .response(completionHandler: completionHandler)
        return CancelToken(request: uploadRequest)
    }
    
    
    /// DoenloadRequest
    private func sendDownloadRequest<Req: NetworkRequest>(
        _ request: Req,
        destination: DownloadDestination?,
        progress: @escaping ((Progress) -> Void),
        completionHandler: @escaping RequestableCompletion
    ) -> CancelToken {
        
        let downloadRequest = session.download(request, to: destination)
            .downloadProgress(closure: progress)
            .response(completionHandler: completionHandler)
    
        return CancelToken(request: downloadRequest)
    }
    
    private func handleDecision<Req: NetworkRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        decisions: [NetworkDecision],
        plugins: [HTTPPlugin],
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) {
        
        if decisions.isEmpty {
            handler(.failure(NetworkError.Decision.decisionsIsEmpty))
            return
        }
        
        var decisions = decisions
        var currentDecision = decisions.removeFirst()
        
        if var _currentDecision = currentDecision as? LogDecision {
            _currentDecision.endTime = Date()
            currentDecision = _currentDecision
        }
        
        if !currentDecision.shouldApply(request: request, data: data, response: response) {
            handleDecision(request: request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
            return
        }

        currentDecision.apply(request: request, data: data, response: response) { action in
            switch action {
            case .next(let request, let data, let response):
                self.handleDecision(request: request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
            case .restart(let decisions):
                self.send(request, decisions: decisions, plugins: plugins, handler: handler)
            case .errored(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            case .done(let value):
                DispatchQueue.main.async {
                    handler(.success(value))
                }
            }
        }
    }
}
