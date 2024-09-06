//
//  ViewControllerProtocol.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import UIKit
import RxSwift
import RxCocoa

/// Protocol defining the behavior of the ViewController. of SocialNetworkUIKit
protocol ViewControllerProtocol: AnyObject {
    func setupBindings()
    func configure(with viewModel: PostsViewModelProtocol)
}
