//
//  ResultViewController.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
struct ResultViewController_Preview: PreviewProvider {
    static var vc: ResultViewController = ResultViewController()
    static var previews: some SwiftUI.View {
        vc.previewGroups()
    }
}

final class ResultViewController: BaseViewController {
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
        flowLayout.itemSize = .init(width: width, height: width)
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
    private let viewModel: ResultViewModel

    // Life cycle
    init(viewModel: ResultViewModel = ResultViewModel(text: "", perPage: "")) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionStream()
        observerStream()
        
        viewModel.loadNext()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action Stream

private extension ResultViewController {
    
    func actionStream() {
        
    }
}

// MARK: - Observer Stream

private extension ResultViewController {
    
    func observerStream() {
        viewModel.failure
            .map { ("Oops!", $0) }
            .bind(to: failureBinder)
            .disposed(by: bag)
        
        viewModel.reload
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }).disposed(by: bag)
    }
}

// MARK: - UICollectionViewDelegate

extension ResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.numberOfItemsInSection - 1 == indexPath.row {
            viewModel.loadNext()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ResultViewController: UICollectionViewDataSource {
    
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

// MARK: - Helper

private extension ResultViewController {
    
    var failureBinder: Binder<(String?, String?)> {
        Binder(self) { target, value in
            target.showAlert(title: value.0, message: value.1, handler: { _ in
                target.navigationController?.popViewController(animated: true)
            })
        }
    }
}

// MARK: - Setup UI methods

private extension ResultViewController {

    func setupUI() {

        navigationItem.title = "Result"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
