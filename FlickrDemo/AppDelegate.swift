//
//  AppDelegate.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit

@_exported import RxSwift
@_exported import RxCocoa
import SnapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabbar = TabbarViewController()
        window!.rootViewController = tabbar
        window!.makeKeyAndVisible()
        return true
    }

}

