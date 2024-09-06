//
//  FavoritesViewController.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import RxSwift
import RxCocoa

/// ViewController responsible for displaying favorite posts
class FavoritesViewController: UIViewController, ViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private var viewModel: PostsViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.register(UINib(nibName: PostCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PostCell.reuseIdentifier)
        tableView.separatorColor = .clear
    }
    
    // MARK: - ViewControllerProtocol Methods
    
    func configure(with viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
    }

    func setupBindings() {
        ///Using driver ensure main thread and simplicity
        viewModel.favoritePostsObservable
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "PostCell", cellType: PostCell.self)) { (row, post, cell) in
                cell.configure(with: post, imageName: nil)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        // Handle placeholder visibility in the same binding
        viewModel.favoritePostsObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] posts in
                self?.placeholderLabel.isHidden = !posts.isEmpty
                self?.tableView.isHidden = posts.isEmpty
            })
            .disposed(by: disposeBag)
    }
}
