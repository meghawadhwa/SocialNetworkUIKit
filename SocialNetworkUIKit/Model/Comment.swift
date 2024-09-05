//
//  Comment.swift
//  SocialNetwork
//
//  Created by Megha Wadhwa on 03/09/24.
//

import RealmSwift

/// A model representing a comment, stored in the Realm database.
/// Each comment contains an ID, name, email, and body content.
class Comment: Object, Identifiable, Codable {
    /// The unique identifier for the comment.
    @Persisted(primaryKey: true) var id: Int
    
    /// The name of the person who made the comment.
    @Persisted var name: String
    
    /// The email of the person who made the comment.
    @Persisted var email: String
    
    /// The body content of the comment.
    @Persisted var body: String

    /// Coding keys used for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case body
    }
}
