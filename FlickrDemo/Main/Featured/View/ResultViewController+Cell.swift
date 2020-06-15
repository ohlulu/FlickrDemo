//
//  ResultViewController+Cell.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import Kingfisher

protocol ResultCellModelProtocol {
    var url: URL? { get }
    var isFavorit: Bool { get }
}

extension ResultCellModelProtocol {
    var isFavorit: Bool { false }
}

extension ResultViewController {
    
    final class Cell: UICollectionViewCell {
        
        // UI element
        private lazy
        var imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        // Life cycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: - Helper function

extension ResultViewController.Cell {
    
    func configCell(_ model: ResultCellModelProtocol) {
        imageView.kf.setImage(with: model.url, options: [.transition(.fade(0.2))])
    }
}

// MARK: - Setup UI methods

private extension ResultViewController.Cell {
    
    func setupUI() {
        
        contentView.backgroundColor = .lightGray
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
