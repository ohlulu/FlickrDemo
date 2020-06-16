//
//  DownloadRequestable.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

struct BaseDownloadResponseModel: Decodable {
    
    let fileURL: URL
}

protocol DownloadRequestable: NetworkRequest where Response == BaseDownloadResponseModel {

    var destination: DownloadDestination { get }
}

extension DownloadRequestable {
    
    var task: Task { .download(destination) }
}
