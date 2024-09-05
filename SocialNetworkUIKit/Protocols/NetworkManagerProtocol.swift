//
//  NetworkManagerProtocol.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import Foundation
import RxSwift

/// Protocol defining the behavior for network interactions.
protocol NetworkManagerProtocol {
    func fetchPosts() -> Observable<[Post]>
}
