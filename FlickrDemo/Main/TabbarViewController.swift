//
//  TabbarViewController.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/15.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit

import SwiftUI

@available(iOS 13.0, *)
struct TabbarViewController_Preview: PreviewProvider {
    static var vc: TabbarViewController = TabbarViewController()
    static var previews: some SwiftUI.View {
        vc.previewGroups()
    }
}

final class TabbarViewController: UITabBarController {
    
    // life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Setup UI methods

private extension TabbarViewController {
    
    func setupUI() {
        
        let favoritesVM = FavoritesViewModel(repository: LocalImageRepository())
        let favoritesVC = initialTab(vc: ResultViewController(viewModel: favoritesVM), item: .favorites, tag: 1)
        viewControllers = [
            initialTab(vc: FeaturedViewController(), item: .featured, tag: 0),
            favoritesVC
        ]
    }
    
    func initialTab(vc: UIViewController, item: UITabBarItem.SystemItem, tag: Int) -> UIViewController {
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: item, tag: tag)
        vc.tabBarItem.title = title
        return BaseNavigationController(root: vc)
    }
}
