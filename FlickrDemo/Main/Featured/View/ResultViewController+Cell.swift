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
    var imageURL: URL? { get }
    var title: String { get }
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
        
        private lazy
        var titleLabel = UILabel()
        
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
        imageView.kf.setImage(with: model.imageURL, options: [.transition(.fade(0.2))])
        titleLabel.text = model.title
    }
}

// MARK: - Setup UI methods

private extension ResultViewController.Cell {
    
    func setupUI() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
