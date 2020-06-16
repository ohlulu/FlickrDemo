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
    
    init(url: URL, title: String) {
        
        let title = title.replacingOccurrences(of: " ", with: "")
        baseURL = url
        
        destination = {  _, _ in
            let manager = FileManager.default
            let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var fileURL = documentsURL.appendingPathComponent("\(title).jpg")
            if manager.fileExists(atPath: fileURL.path) {
                fileURL = documentsURL.appendingPathComponent("\(title)_\(Date().toString()).jpg")
            }
            return (fileURL, [.createIntermediateDirectories])
        }
    }
}
