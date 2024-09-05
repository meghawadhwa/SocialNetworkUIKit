//
//  PostsViewModelProtocol.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import Foundation
import RxSwift
import RealmSwift

// MARK: - PostsViewModelProtocol
/// Protocol defining the behavior of the PostsViewModel.
protocol PostsViewModelProtocol: AnyObject {
    var postsObservable: Observable<[Post]> { get }
    var favoritePostsObservable: Observable<[Post]> { get }
    func fetchPosts()
    func toggleFavorite(post: Post)
    func imageName(for post: Post) -> String
}
