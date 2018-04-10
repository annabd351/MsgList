//
//  MessageData.swift
//  MsgList
//
//  Created by Anna Dickinson on 4/9/18.
//  Copyright © 2018 Anna Dickinson. All rights reserved.
//

import Foundation

// Strongly typed, decodable, immutable version of incoming JSON message dictionary.

private let decoder: JSONDecoder = {
    let newDecoder = JSONDecoder()
    newDecoder.dateDecodingStrategy = .iso8601
    return newDecoder
}()

struct MessageData: Codable {
    let results: [Message]
    
    static func messages(from url: URL) throws -> [Message] {
        return try decoder.decode(MessageData.self, from: Data(contentsOf: url)).results.sorted { $0.created < $1.created }
    }
}

struct Message: Codable {
    let id: Int
    let content: String
    let created: Date
    let user: User
    let isOutgoing: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case content
        case created
        case user
        case isOutgoing = "is_outgoing"
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let displayName: String
    let imageURL: URL
    let initials: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case displayName = "display_name"
        case imageURL = "image_100x100"
        case initials
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
