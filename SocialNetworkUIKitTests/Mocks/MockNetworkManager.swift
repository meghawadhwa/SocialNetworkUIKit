//
//  MockNetworkManager.swift
//  SocialNetworkUIKitTests
//
//  Created by Megha Wadhwa on 05/09/24.
//

import RxSwift
import RxCocoa
@testable import SocialNetworkUIKit

// Mock NetworkManager to simulate API behavior
class MockNetworkManager: NetworkManagerProtocol {
    var postsSubject = PublishSubject<[Post]>()

    func fetchPosts() -> Observable<[Post]> {
        return postsSubject.asObservable()
    }
}
