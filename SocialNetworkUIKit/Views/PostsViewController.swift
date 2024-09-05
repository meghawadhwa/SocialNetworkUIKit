//
//  PostsViewController.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//
import UIKit
import RxSwift
import RxCocoa

// MARK: - PostsViewController
/// ViewController that displays a list of posts and allows toggling favorites.
class PostsViewController: UIViewController, PostsViewControllerProtocol {
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    private var viewModel: PostsViewModelProtocol!
    private let disposeBag = DisposeBag()
    private var posts: [Post] = []
        
    // MARK: - Initialization

        /// Required initializer when using Storyboard
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        /// Call this method to inject the viewModel after instantiation.
        /// - Parameter viewModel: The ViewModel managing posts.
        func configure(with viewModel: PostsViewModelProtocol) {
            self.viewModel = viewModel
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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Binds the ViewModel observables to the ViewController's UI components.
    private func setupBindings() {
        // Observe posts and update the table view
        viewModel.postsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] posts in
                self?.displayPosts(posts)
            }, onError: { [weak self] error in
                self?.displayError(error)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - PostsViewControllerProtocol Methods
    
    /// Displays the list of posts in the table view.
    /// - Parameter posts: Array of `Post` objects to display.
    func displayPosts(_ posts: [Post]) {
        self.posts = posts
        tableView.reloadData()
    }
    
    /// Displays an error message in case of an error.
    /// - Parameter error: The error to display.
    func displayError(_ error: Error) {
        // Handle error (e.g., show an alert)
        print("Error: \(error.localizedDescription)")
    }
    
    /// Updates the corresponding table view cell for a given post.
    /// - Parameter post: The `Post` object whose cell should be updated.
    func updateCell(for post: Post) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Returns the number of rows in the table view section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    /// Configures and returns the cell for the given index path.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.configure(with: post, imageName: viewModel.imageName(for: post))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        viewModel.toggleFavorite(post: post)
    }
}
