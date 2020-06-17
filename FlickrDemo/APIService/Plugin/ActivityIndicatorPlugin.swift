//
//  ActivityIndicatorPlugin.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit

final class ActivityIndicatorPlugin: HTTPPlugin {
    
    static private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .red
        indicator.transform = .init(scaleX: 3, y: 3)
        let bounds = UIScreen.main.bounds
        indicator.center = .init(x: bounds.midX, y: bounds.midY)
        return indicator
    }()
    
    func willSend<Req: HTTPRequest>(_ request: Req) {
        let keyWindow = UIApplication.keyWindow
        keyWindow?.addSubview(ActivityIndicatorPlugin.indicator)
        keyWindow?.bringSubviewToFront(ActivityIndicatorPlugin.indicator)
        ActivityIndicatorPlugin.indicator.startAnimating()
    }
    
    func didReceive<Req: HTTPRequest>(_ request: Req, result: ResultType) {
        ActivityIndicatorPlugin.indicator.stopAnimating()
        if ActivityIndicatorPlugin.indicator.superview != nil {
            ActivityIndicatorPlugin.indicator.removeFromSuperview()
        }
    }
}
