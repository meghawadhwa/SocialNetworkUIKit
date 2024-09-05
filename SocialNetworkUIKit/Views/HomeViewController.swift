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
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoginIfNeeded()
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
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        // Bind the isLoginPresented behavior relay to present the login screen
        isLoginPresented
            .asDriver()
            .drive(onNext: { [weak self] shouldPresent in
                if shouldPresent {
                    self?.showLoginScreen()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Show Login If Needed
    private func showLoginIfNeeded() {
        // Simulate login check. In real apps, this could be based on authentication state.
        if !hasShownLogin {
            isLoginPresented.accept(true)
        } // Present the login screen when the HomeView appears
    }
    
    // MARK: - Present Login Screen
    private func showLoginScreen() {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(UINavigationController(rootViewController: loginVC), animated: true) {
            self.hasShownLogin = true
        }
    }
}
