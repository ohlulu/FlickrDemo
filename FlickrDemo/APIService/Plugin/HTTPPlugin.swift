//
//  HTTPPlugin.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public protocol HTTPPlugin: class {
    
    typealias ResultType = (Data?, URLResponse?, Error?)
    
    func willSend<Req: HTTPRequest>(_ request: Req)
    func didReceive<Req: HTTPRequest>(_ request: Req, result: ResultType)
}

public extension HTTPPlugin {
//    func willSend<Req: HTTPRequest>(_ request: Req) { }
//    func didReceive<Req: HTTPRequest>(_ request: Req, result: ResultType) { }
}
