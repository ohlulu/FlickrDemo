//
//  BaseViewController.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var bag = DisposeBag()
    
    // MARK: UI element
    
    // MARK: Private property
    
    private var canPopViewController = true

    // MARK: - Life cycle

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI methods

private extension BaseViewController {

    func setupUI() {
        view.backgroundColor = .white
    }
}
