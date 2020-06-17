//
//  Notificationable.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

protocol Notificationable { }

extension Notificationable {
    
    static var notificationName: Notification.Name {
        .init(String.init(describing: Self.self))
    }

    static var userInfoKey: String {
        "UserInfoKey"
    }
    
    init(_ notification: Notification) {
        guard let value = notification.userInfo?[Self.userInfoKey] as? Self else {
            fatalError()
        }
        self = value
    }
}

extension NotificationCenter {

    func post<T>(_ notificationable: T, object: Any? = nil) where T: Notificationable {
        post(name: T.notificationName, object: object, userInfo: [T.userInfoKey: notificationable])
    }
    
    func addObserver<T>(
        _ notificationType: T.Type,
        object: Any? = nil,
        queue: OperationQueue? = .main,
        using: @escaping (Notification) -> Void)
        where T: Notificationable
    {
        addObserver(forName: T.notificationName, object: object, queue: queue, using: using)
    }
    
    func addObserver<T>(
        _ notificationType: T.Type,
        observer: Any,
        selector: Selector,
        object: Any? = nil)
        where T: Notificationable
    {
        addObserver(observer, selector: selector, name: T.notificationName, object: object)
    }
}
