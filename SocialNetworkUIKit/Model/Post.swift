//
//  Posts.swift
//  SocialNetwork
//
//  Created by Megha Wadhwa on 03/09/24.
//

import RealmSwift

/// A model representing a post, stored in the Realm database.
/// Each post contains an ID, title, body, favorite status, and associated comments.
class Post: Object, Identifiable, Codable {
    /// The unique identifier for the post.
    @Persisted(primaryKey: true) var id: Int
    
    /// The title of the post.
    @Persisted var title: String
    
    /// The body content of the post.
    @Persisted var body: String
    
    /// A boolean flag indicating whether the post is marked as favorite.
    @Persisted var isFavorite: Bool = false
    
    /// A list of comments associated with the post.
    @Persisted var comments: List<Comment>

    /// Coding keys used for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
    }
}
