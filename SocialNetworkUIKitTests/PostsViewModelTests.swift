//
//  PostsViewModelTests.swift
//  SocialNetworkUIKitTests
//
//  Created by Megha Wadhwa on 05/09/24.
//

import XCTest
import RealmSwift
import RxSwift
import RxTest
@testable import SocialNetworkUIKit

class PostsViewModelTests: XCTestCase {
    
    var viewModel: PostsViewModel!
    var disposeBag: DisposeBag!
    var mockNetworkManager: MockNetworkManager!
    var scheduler: TestScheduler!
    var realm: Realm!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        mockNetworkManager = MockNetworkManager()
        scheduler = TestScheduler(initialClock: 0)
        
        // In-memory Realm for testing
        var config = Realm.Configuration()
        config.inMemoryIdentifier = self.name
        realm = try! Realm(configuration: config)
        
        viewModel = PostsViewModel(networkManager: mockNetworkManager, disposeBag: disposeBag, realm: realm)
    }

    override func tearDown() {
        disposeBag = nil
        mockNetworkManager = nil
        realm = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchPostsSuccessful() {
        // Given
        let posts = [
            createPost(id: 1, title: "Post 1", body: "Body 1", isFavorite: false),
            createPost(id: 2, title: "Post 2", body: "Body 2", isFavorite: true)
        ]
        
        let observer = scheduler.createObserver([Post].self)
        
        viewModel.postsObservable
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // When
        viewModel.fetchPosts()
        mockNetworkManager.postsSubject.onNext(posts)
        
        // Then
        let expectedEvents = [
            Recorded.next(0, []), // Initial empty state
            Recorded.next(0, posts) // After fetching posts
        ]
        XCTAssertEqual(observer.events, expectedEvents)
        
        // Verify that posts were saved locally in Realm
        let savedPosts = realm.objects(Post.self)
        XCTAssertEqual(savedPosts.count, posts.count)
    }
    
    func testToggleFavoritePost() {
        // Given
        let post = createPost(id: 1, title: "Post 1", body: "Body 1", isFavorite: false)
        try! realm.write {
            realm.add(post, update: .modified)
        }
        
        let favoriteObserver = scheduler.createObserver([Post].self)
        viewModel.favoritePostsObservable
            .subscribe(favoriteObserver)
            .disposed(by: disposeBag)
        
        // When
        viewModel.toggleFavorite(post: post)
        
        // Then
        let expectedFavoriteEvents = [
            Recorded.next(0, []), // Initially no favorite posts
            Recorded.next(0, [post]) // After toggling favorite status
        ]
        XCTAssertEqual(favoriteObserver.events, expectedFavoriteEvents)
        
        // Verify that the favorite status was updated in Realm
        let updatedPost = realm.object(ofType: Post.self, forPrimaryKey: post.id)
        XCTAssertTrue(updatedPost?.isFavorite ?? false)
    }
    
    func testNoPostsInitially() {
        // Given
        let observer = scheduler.createObserver([Post].self)
        
        // When
        viewModel.postsObservable
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(observer.events, [Recorded.next(0, [])])
    }
    
    func testNoFavoritePostsInitially() {
        // Given
        let observer = scheduler.createObserver([Post].self)
        
        // When
        viewModel.favoritePostsObservable
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        // Then
        XCTAssertEqual(observer.events, [Recorded.next(0, [])])
    }
    
    // Helper method to create a Post object with specified properties
    private func createPost(id: Int,
                            title: String,
                            body: String,
                            isFavorite: Bool) -> Post {
        let post = Post()
        post.id = id
        post.title = title
        post.body = body
        post.isFavorite = isFavorite
        return post
    }

}
