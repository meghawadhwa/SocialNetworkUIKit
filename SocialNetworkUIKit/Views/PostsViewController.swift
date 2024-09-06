//
//  PostsViewController.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//
import RxSwift
import RxCocoa
import UIKit

class PostsViewController: UIViewController, ViewControllerProtocol {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    private var viewModel: PostsViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    
    /// Required initializer when using Storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchPosts()
    }
    
    // MARK: - Setup Methods
    
    /// Configures the user interface for the view controller.
    private func setupUI() {
        title = "Posts"
        tableView.register(UINib(nibName: PostCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.separatorColor = .clear
    }
    
    // MARK: - ViewControllerProtocol Methods
    
    /// Call this method to inject the viewModel after instantiation.
    /// - Parameter viewModel: The ViewModel managing posts.
    func configure(with viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
    }

    /// Binds the ViewModel observables to the ViewController's UI components.
    func setupBindings() {
        ///Using driver ensure main thread and simplicity
        viewModel.postsObservable
            .asDriver(onErrorJustReturn: []) // Convert to Driver and handle errors
            .drive(tableView.rx.items(cellIdentifier: PostCell.reuseIdentifier, cellType: PostCell.self)) { (row, post, cell) in
                cell.configure(with: post, imageName: self.viewModel.imageName(for: post))
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        // Handle cell selection
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)
            })
            .disposed(by: disposeBag)
    }
}
