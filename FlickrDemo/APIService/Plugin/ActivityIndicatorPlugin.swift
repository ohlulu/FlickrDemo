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
        indicator.style = .gray
        indicator.layer.shadowColor = UIColor.black.cgColor
        indicator.layer.shadowRadius = 4
        indicator.layer.shadowOffset = .init(width: 2, height: 2)
        indicator.layer.shadowOpacity = 0.6
        indicator.backgroundColor = .white
        let bounds = UIScreen.main.bounds
        indicator.center = .init(x: bounds.midX, y: bounds.midY)
        return indicator
    }()
    
    func willSend<Req: NetworkRequest>(_ request: Req) {
        let keyWindow = UIApplication.keyWindow
        keyWindow?.addSubview(ActivityIndicatorPlugin.indicator)
        keyWindow?.bringSubviewToFront(ActivityIndicatorPlugin.indicator)
        ActivityIndicatorPlugin.indicator.startAnimating()
    }
    
    func didReceive<Req: NetworkRequest>(_ request: Req, result: ResultType) {
        ActivityIndicatorPlugin.indicator.stopAnimating()
        if ActivityIndicatorPlugin.indicator.superview != nil {
            ActivityIndicatorPlugin.indicator.removeFromSuperview()
        }
    }
}
