//
//  ViewControllerProtocol.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - PostsViewControllerProtocol
/// Protocol defining the behavior of the ViewController. of SocialNetworkUIKit
protocol PostsViewControllerProtocol: AnyObject {
    func displayPosts(_ posts: [Post])
    func displayError(_ error: Error)
    func updateCell(for post: Post)
}
