//
//  ActivityIndicatorPlugin.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit

struct ActivityIndicatorPlugin: HTTPPlugin {
    
    static private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.transform = .init(scaleX: 2, y: 2)
        let bounds = UIScreen.main.bounds
        indicator.center = .init(x: bounds.midX, y: bounds.midY)
        return indicator
    }()
    
    func willSend<Req: NetworkRequest>(_ request: Req) {
        UIApplication.keyWindow?.addSubview(ActivityIndicatorPlugin.indicator)
        ActivityIndicatorPlugin.indicator.startAnimating()
    }
    
    func didReceive<Req: NetworkRequest>(_ request: Req, result: ResultType) {
        ActivityIndicatorPlugin.indicator.stopAnimating()
        if ActivityIndicatorPlugin.indicator.superview != nil {
            ActivityIndicatorPlugin.indicator.removeFromSuperview()
        }
    }
}
