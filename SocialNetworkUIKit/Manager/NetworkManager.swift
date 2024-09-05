//
//  NetworkManager.swift
//  SocialNetwork
//
//  Created by Megha Wadhwa on 03/09/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let baseUrl = "https://jsonplaceholder.typicode.com"

    func fetchPosts() -> Observable<[Post]> {
        let url = "\(baseUrl)/posts"
        return Observable.create { observer in
            AF.request(url).responseDecodable(of: [Post].self) { response in
                switch response.result {
                case .success(let posts):
                    observer.onNext(posts)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchComments(for postId: Int) -> Observable<[Comment]> {
        let url = "\(baseUrl)/posts/\(postId)/comments"
        return Observable.create { observer in
            AF.request(url).responseDecodable(of: [Comment].self) { response in
                switch response.result {
                case .success(let comments):
                    observer.onNext(comments)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
