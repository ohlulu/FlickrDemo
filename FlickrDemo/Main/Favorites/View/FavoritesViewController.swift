//
//  FavoritesViewController.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import SwiftUI

final class FavoritesViewController: BaseViewController {

    private struct Constant {
        let isnet: CGFloat = 10
        let minimumInteritemSpacing: CGFloat = 10
        let minimumLineSpacing: CGFloat = 10
        var spacing: CGFloat { isnet + minimumInteritemSpacing + minimumLineSpacing }
    }
    
    // UI element
    private lazy
    var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: layoutConst.isnet, left: layoutConst.isnet, bottom: layoutConst.isnet, right: layoutConst.isnet)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = layoutConst.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = layoutConst.minimumLineSpacing
        let width = (UIScreen.main.bounds.width - layoutConst.spacing) / 2
        flowLayout.itemSize = .init(width: width, height: width + 24)
        return flowLayout
    }()
    
    private lazy
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // property
    private let layoutConst = Constant()
    private let viewModel: ImageListViewModel2

    // Life cycle
    init(viewModel: ImageListViewModel2) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionStream()
        observerStream()
        viewModel.loadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        let model = viewModel.model(at: indexPath)
        cell.configCell(model)
        return cell
    }
}



// MARK: - Action Stream

private extension FavoritesViewController {
    
    func actionStream() {
        
    }
}

// MARK: - Observer Stream

private extension FavoritesViewController {
    
    func observerStream() {
        viewModel.reload
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }).disposed(by: bag)
    }
}

// MARK: - Helper

private extension FavoritesViewController {

}

// MARK: - Setup UI methods

private extension FavoritesViewController {

    func setupUI() {

        navigationItem.title = "Favorites"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
