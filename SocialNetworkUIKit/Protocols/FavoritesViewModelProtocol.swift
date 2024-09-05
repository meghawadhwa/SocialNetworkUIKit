//
//  FavoritesViewModelProtocol.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import RxSwift
import RxCocoa

/// Protocol for ViewModel handling favorite posts
protocol FavoritesViewModelProtocol {
    var favoritePostsObservable: Observable<[Post]> { get }
    func fetchFavoritePosts()
}
