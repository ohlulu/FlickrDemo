//
//  HTTPDecision.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public enum DecisionAction<Req: NetworkRequest> {
    case next(Req, Data, HTTPURLResponse)
    case restart([NetworkDecision])
    case errored(Error)
    case done(Req.Response)
}


public protocol NetworkDecision {
    
    func shouldApply<Req: NetworkRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse
    ) -> Bool
    
    
    func apply<Req: NetworkRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        action: @escaping (DecisionAction<Req>) -> Void
    )
}
