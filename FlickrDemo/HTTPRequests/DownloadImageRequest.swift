//
//  DownloadImageRequest.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct DownloadImageRequest: DownloadRequestable {
    
    let destination: DownloadDestination
    var tag: String { "👉 download image"}
    var baseURL: URL
    var responseModel: BaseDownloadResponseModel?
    
    init(url: URL, title: String) {
        
        let title = title.replacingOccurrences(of: " ", with: "")
        baseURL = url
        
        destination = {  _, _ in
            let manager = FileManager.default
            let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = title.base64Encoded() ?? UUID().uuidString
            let fileURL = documentsURL.appendingPathComponent("\(fileName).jpg")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
    }
}
