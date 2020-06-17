//
//  FeaturedViewController.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
struct FeaturedViewController_Preview: PreviewProvider {
    static var vc: FeaturedViewController = FeaturedViewController()
    static var previews: some SwiftUI.View {
        vc.previewGroups()
    }
}

final class FeaturedViewController: BaseViewController {

    // UI element
    private lazy
    var contentTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 1))
        textField.leftViewMode = .always
        textField.placeholder = "搜尋的內容"
        return textField
    }()
    
    private lazy
    var perPageTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: 12, height: 1))
        textField.leftViewMode = .always
        textField.placeholder = "每頁呈現的數量"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy
    var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setBackgroundImage(.create(from: .gray), for: .disabled)
        button.setBackgroundImage(.create(from: .systemBlue), for: .normal)
        return button
    }()

    // property
    private let viewModel: FeaturedViewModel

    // Life cycle
    init(viewModel: FeaturedViewModel = FeaturedViewModel()) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionStream()
        observerStream()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action Stream

private extension FeaturedViewController {
    
    func actionStream() {
        
        contentTextField.rx.text
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.contentTextDidChange(text)
            }).disposed(by: bag)
        
        perPageTextField.rx.text
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.viewModel.perPageTextDidChange(text)
            }).disposed(by: bag)
        
        searchButton.rx.tap
            .flatMap { [weak self] _  in
                return (self?.viewModel.didTapSearchButton(
                    text: self?.contentTextField.text,
                    perPage: self?.perPageTextField.text) ?? .never())
            }
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    let vm = ResultViewModel(text: model.0, perPage: model.1)
                    let vc = ResultViewController(viewModel: vm)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error) :
                    self.showAlert(title: "Oops!", message: error.localizedDescription, handler: nil)
                }
                
            }).disposed(by: bag)
    }
}

// MARK: - Observer Stream

private extension FeaturedViewController {
    
    func observerStream() {
        viewModel.buttonEnable
            .drive(searchButton.rx.isEnabled)
            .disposed(by: bag)
    }
}

// MARK: - Helper

private extension FeaturedViewController {

}

// MARK: - Setup UI methods

private extension FeaturedViewController {

    func setupUI() {

        navigationItem.title = "輸入搜尋"
        
        view.addSubview(contentTextField)
        contentTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(40)
        }
        
        view.addSubview(perPageTextField)
        perPageTextField.snp.makeConstraints { (make) in
            make.height.leading.trailing.equalTo(contentTextField)
            make.top.equalTo(contentTextField.snp.bottom).offset(12)
        }
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.leading.trailing.height.equalTo(contentTextField)
            make.top.equalTo(perPageTextField.snp.bottom).offset(12)
        }
    }
}
