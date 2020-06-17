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
    var title: String { get }
//    var imageURL: URL? { get }
    var imageConfigurator: ((UIImageView) -> Void)? { get }
}
    
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
    
    // Property
    private var task: DownloadTask?
    
    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
    }
}


// MARK: - Helper function

extension Cell {
    
    func configCell(_ model: ResultCellModelProtocol) {
//        let image = UIImage(contentsOfFile: model.imageURL!.path)
//        imageView.image = image
//        task = imageView.kf.setImage(with: model.imageURL, options: [.transition(.fade(0.2))])
        model.imageConfigurator?(imageView)
        titleLabel.text = model.title
    }
}

// MARK: - Setup UI methods

private extension Cell {
    
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
