//
//  PostCell.swift
//  SocialNetworkUIKit
//
//  Created by Megha Wadhwa on 05/09/24.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "PostCell"
    
    var favoriteButtonAction: (() -> Void)?
    
    @IBOutlet private var cardView: UIView!

    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var bodyLabel: UILabel!
    
    @IBOutlet private var imageIcon: UIButton!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Setup Methods
    
    /// Configures the UI components of the cell.
    private func setupUI() {
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.darkGray.cgColor
        cardView.layer.cornerRadius = 12.0
        cardView.clipsToBounds = true
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with the given post.
    /// - Parameters:
    ///   - post: The `Post` object to display.
    ///   - imageName: imageName indicating if the post is a favorite.
    func configure(with post: Post, imageName: String?) {
        setupUI()
        titleLabel.text = post.title
        bodyLabel.text = post.body
        guard let imageName else {
            imageIcon.isHidden = true
            return
        }
        imageIcon.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
