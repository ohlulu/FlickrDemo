//
//  Extensions.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit

extension UIImage {
    static func create(from color: UIColor, size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIApplication {
    static var keyWindow: UIWindow? { UIApplication.shared.windows.filter { $0.isKeyWindow }.first }
}


extension Date {
    
    func toString(format: String = "yyyyMMddHHmmss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}

