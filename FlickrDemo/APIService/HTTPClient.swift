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
        plugins: [HTTPPlugin] = [],
        progress: @escaping ((Progress) -> Void) = { _ in },
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) -> CancelToken {
        
        var decisions = decisions ?? request.decisions
        if !decisions.isEmpty {
            if var first = decisions[0] as? LogDecision {
                first.startTime = Date()
                decisions.removeFirst()
                decisions.insert(first, at: 0)
            }
        }
        
        let responseHandler = { (afResponse: AFDataResponse<Data>) in
            
            guard let httpResponse = afResponse.response else {
                handler(.failure(NetworkError.Response.nilResponse))
                return
            }
            
            switch afResponse.result {
            case .success(let data):
                self.handleDecision(
                    request: request,
                    data: data,
                    response: httpResponse,
                    decisions: decisions,
                    plugins: plugins,
                    handler: handler
                )
            case .failure(let error):
                handler(.failure(NetworkError.AF.error(error)))
            }
        }
        
        switch request.task {
        case .normal:
            return sendNormalRequest(request, responseHandler: responseHandler)
        case .upload(let multipartColumns):
            do {
                return try sendUploadRequest(request, multiparColumns: multipartColumns, progress: progress, responseHandler: responseHandler)
            } catch {
                handler(.failure(error))
            }
        }
        
        return CancelToken()
    }

    private func sendNormalRequest<Req: NetworkRequest>(
        _ request: Req,
        responseHandler: @escaping (AFDataResponse<Data>) -> Void
    ) -> CancelToken {
        let request = session.request(request)
            .responseData(completionHandler: responseHandler)
        return CancelToken(request: request)
    }
    
    private func sendUploadRequest<Req: NetworkRequest>(
        _ request: Req,
        multiparColumns: [MultipartColumn],
        progress: @escaping ((Progress) -> Void),
        responseHandler: @escaping (AFDataResponse<Data>) -> Void
    ) throws -> CancelToken {
        
        let multipartFormData = MultipartFormData()
        try multipartFormData.adapted(columns: multiparColumns)
        
        let uploadRequest = session.upload(multipartFormData: multipartFormData, with: request)
            .uploadProgress(closure: progress)
            .responseData(completionHandler: responseHandler)
        return CancelToken(request: uploadRequest)
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
