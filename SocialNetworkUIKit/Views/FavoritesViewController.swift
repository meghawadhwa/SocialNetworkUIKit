//
//  FavoritesViewController.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import UIKit
import RxSwift
import RxCocoa

/// ViewController responsible for displaying favorite posts
class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private var viewModel: PostsViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var isCommentsViewPresented = false
    private var commentsViewModel = CommentsViewModel()
    private var favouritePosts: [Post] = []

    // MARK: - Initialization
    
    /// Initializes the view controller with a view model.
    /// - Parameter viewModel: The view model for handling favorite posts.
    func configure(with viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tableView.separatorColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.favoritePostsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] posts in
                self?.favouritePosts = posts
                self?.tableView.reloadData()
                self?.updatePlaceholderVisibility()
            })
            .disposed(by: disposeBag)
    }
    
// Show/hide the placeholder label based on the number of favorite posts
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !favouritePosts.isEmpty
        tableView.isHidden = favouritePosts.isEmpty
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = favouritePosts[indexPath.row]
        cell.configure(with: post, imageName: nil)
        cell.selectionStyle = .none
        return cell
    }
}
