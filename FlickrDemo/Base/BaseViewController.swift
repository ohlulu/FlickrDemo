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
    
    // Life cycle
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

extension BaseViewController {

    var alertBinder: Binder<(String?, String?, ((UIAlertAction) -> Void)?)> {
        Binder(self) { target, value in
            target.showAlert(title: value.0, message: value.1, handler: value.2)
        }
    }
    
    func showAlert(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup UI methods

private extension BaseViewController {

    func setupUI() {
        view.backgroundColor = .white
    }
}
