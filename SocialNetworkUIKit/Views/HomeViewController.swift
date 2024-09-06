//
//  ViewController.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UITabBarController {
    
    private let disposeBag = DisposeBag()
    private var isLoginPresented = BehaviorRelay<Bool>(value: false)
    private var hasShownLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup TabBar
    private func setupTabBar() {
        // Assuming you have a PostsViewController and FavoritesViewController set up in storyboard
        let postsViewModel = PostsViewModel()
        let postsViewController = storyboard?.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        postsViewController.configure(with: postsViewModel)
        let favoritesViewController = storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        favoritesViewController.configure(with: postsViewModel)
        postsViewController.tabBarItem = UITabBarItem(
            title: PostConstants.title,
            image: UIImage(systemName: PostConstants.tabIcon),
            selectedImage: nil
        )
        
        favoritesViewController.tabBarItem = UITabBarItem(
            title: FavouriteConstants.title,
            image: UIImage(systemName: FavouriteConstants.selectedIcon),
            selectedImage: nil
        )
        
        self.viewControllers = [postsViewController, favoritesViewController]
    }
}
