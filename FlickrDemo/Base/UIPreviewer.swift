//
//  UIPreviewer.swift
//  ohlulu
//
//  Created by Ohlulu on 2020/5/27.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
/// Device list from: https://developer.apple.com/documentation/swiftui/list/3270295-previewdevice
public extension PreviewDevice {
    /// No iPhone 11 Pro Max yet, use iPhone Xs Max
    static let iPhone11ProMax = PreviewDevice(rawValue: "iPhone Xs Max")
    /// No iphone 11 Pro yet, use iphone Xs
    static let iPhone11Pro = PreviewDevice(rawValue: "iPhone Xs")
    /// No iPhone 11 yet, use iPhone XR
    static let iphone11 = PreviewDevice(rawValue: "iphone XR")
    static let iPhone8Plus = PreviewDevice(rawValue: "iphone 8 Plus")
    static let iPhone8 = PreviewDevice(rawValue: "iPhone 8")
    static let iPhoneSE = PreviewDevice(rawValue: "iPhone SE")
    static let iPadMini5 = PreviewDevice(rawValue: "iPad mini (5th generation)")
}

@available(iOS 13.0, *)
struct UIViewControllerPreview: UIViewControllerRepresentable {
    let vc: UIViewController
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UIViewControllerPreview>) -> UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview>) {
        
    }
}

@available(iOS 13.0, *)
extension UIViewController {
    @available(iOS 13.0, *)
    func previewGroups() -> some SwiftUI.View {
        Group {
            UIViewControllerPreview(vc: self)
                .previewDevice(.iPhone11ProMax)
                .previewDisplayName("iPhone11 Pro Max")

            UIViewControllerPreview(vc: self)
                .previewDevice(.iPhone8Plus)
                .previewDisplayName("iPhone8 Plus")

            UIViewControllerPreview(vc: self)
                .previewDevice(.iPhone8)
                .previewDisplayName("iPhone8")

            UIViewControllerPreview(vc: self)
                .previewDevice(.iPhoneSE)
                .previewDisplayName("iPhoneSE")
        }
    }
}
