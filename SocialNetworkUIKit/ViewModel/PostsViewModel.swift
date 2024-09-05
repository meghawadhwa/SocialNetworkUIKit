//
//  PostsViewModel.swift
//  SocialNetwork
//
//  Created by Megha Wadhwa on 03/09/24.
//

import RxSwift
import RealmSwift

// MARK: - PostsViewModel
/// ViewModel for managing posts and their favorite status.
class PostsViewModel: PostsViewModelProtocol {
    
    // MARK: - Properties
    
    /// Observable array of all posts.
    var postsObservable: Observable<[Post]> {
        postsSubject.asObservable()
    }
    
    /// Observable array of favorite posts.
    var favoritePostsObservable: Observable<[Post]> {
        favoritePostsSubject.asObservable()
    }
    
    /// Private subject to hold the current posts.
    private let postsSubject = BehaviorSubject<[Post]>(value: [])
    
    /// Private subject to hold the current favorite posts.
    private let favoritePostsSubject = BehaviorSubject<[Post]>(value: [])
    
    private let networkManager: NetworkManagerProtocol
    private let realm: Realm
    private let disposeBag: DisposeBag
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with necessary dependencies.
    /// - Parameters:
    ///   - networkManager: The network manager used for fetching posts.
    ///   - disposeBag: DisposeBag for managing RxSwift subscriptions.
    ///   - realm: Realm database instance.
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared,
         disposeBag: DisposeBag = DisposeBag(),
         realm: Realm = try! Realm()) {
        self.realm = realm
        self.networkManager = networkManager
        self.disposeBag = disposeBag
        fetchLocalPosts()
    }
    
    // MARK: - Public Methods
    
    /// Fetches posts from the network if not already fetched and saves them locally.
    func fetchPosts() {
        guard (try? postsSubject.value().isEmpty) ?? true else { return }
        
        networkManager.fetchPosts()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] posts in
                self?.savePostsToLocal(posts)
                self?.fetchLocalPosts()
            }, onError: { error in
                print("Error fetching posts: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    /// Toggles the favorite status of a post and updates it in local storage.
    /// - Parameter post: The post whose favorite status will be toggled.
    func toggleFavorite(post: Post) {
        do {
            try realm.write {
                post.isFavorite.toggle()
                realm.add(post, update: .modified)
            }
            fetchLocalPosts()
        } catch {
            print("Error updating favorite status: \(error)")
        }
    }
    
    /// Returns the appropriate image name for a post based on its favorite status.
    /// - Parameter post: The post for which the image name is requested.
    /// - Returns: The image name as a `String`.
    func imageName(for post: Post) -> String {
        let isFavorite = (try? favoritePostsSubject.value().contains(where: { $0.id == post.id })) ?? false
        return isFavorite ? FavouriteConstants.selectedIcon : FavouriteConstants.unselectedIcon
    }
    
    // MARK: - Private Methods
    
    /// Saves posts to the local Realm database.
    /// - Parameter posts: Array of posts to be saved.
    private func savePostsToLocal(_ posts: [Post]) {
        do {
            try realm.write {
                realm.add(posts, update: .modified)
            }
        } catch {
            print("Error saving posts to local: \(error)")
        }
    }
    
    /// Fetches posts from local Realm storage and updates `postsSubject` and `favoritePostsSubject`.
    private func fetchLocalPosts() {
        let allPosts = realm.objects(Post.self)
        postsSubject.onNext(Array(allPosts))
        favoritePostsSubject.onNext(Array(allPosts.filter("isFavorite == true")))
    }
}
