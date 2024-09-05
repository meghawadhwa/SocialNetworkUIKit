//
//  CommentsViewModel.swift
//  SocialNetwork
//
//  Created by Megha Wadhwa on 04/09/24.
//
import Combine
import RxSwift
import RxCocoa
import RealmSwift

/// ViewModel for managing comments related to a specific post
class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private let networkManager: NetworkManager
    private let disposeBag: DisposeBag
    private let realm: Realm
    
    @Published var post: Post? {
        didSet {
            fetchComments()
        }
    }
    
    /// Initializes the ViewModel with necessary dependencies.
    /// - Parameters:
    ///   - networkManager: The network manager used for fetching comments.
    ///   - disposeBag: DisposeBag for managing RxSwift subscriptions.
    ///   - realm: The Realm instance for local database operations.
    init(networkManager: NetworkManager = NetworkManager.shared,
         disposeBag: DisposeBag = DisposeBag(),
         realm: Realm = try! Realm()) {
        self.networkManager = networkManager
        self.disposeBag = disposeBag
        self.realm = realm
        fetchLocalComments()
    }
    
    /// Fetches comments for the selected post from the network and saves them locally.
    func fetchComments() {
        guard let post = post, comments.isEmpty else { return }
        
        networkManager.fetchComments(for: post.id)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] comments in
                self?.saveCommentsToLocal(comments)
                self?.comments = comments
            }, onError: { error in
                print("Error fetching comments: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    /// Saves comments to the local Realm database.
    /// - Parameter comments: Array of comments to be saved.
    private func saveCommentsToLocal(_ comments: [Comment]) {
        do {
            try realm.write {
                for comment in comments {
                    ///Hack: This has been added as comments id also starts at 1 just like posts id
                    ///Adding this to make it unique
                    ///Not a recommended practice
                    comment.id += 9999
                    post?.comments.append(comment)
                }
                realm.add(post!, update: .modified)
            }
        } catch {
            print("Error saving comments to local: \(error)")
        }
    }
    
    /// Fetches posts from local Realm storage and updates `comments
    private func fetchLocalComments() {
        let allComments = realm.objects(Comment.self)
        comments = Array(allComments)
    }
}
