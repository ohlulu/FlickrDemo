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


extension String {
    
    func base64Encoded(encoding: String.Encoding = .utf8) -> String? {
        let plainData = data(using: encoding)
        return plainData?.base64EncodedString()
    }
    
    func base64Decoded(decoding: String.Encoding = .utf8,
                       options: Data.Base64DecodingOptions = .ignoreUnknownCharacters) -> String? {
        let remainder = count % 4

        var padding = ""
        if remainder > 0 {
            padding = String(repeating: "=", count: 4 - remainder)
        }

        guard let data = Data(base64Encoded: self + padding,
                              options: options) else { return nil }

        return String(data: data, encoding: decoding)
    }
}

extension Date {
    
    func toString(format: String = "yyyyMMddHHmmss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
}

