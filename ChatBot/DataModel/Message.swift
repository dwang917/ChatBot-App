//
//  Message.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation
import SwiftData
//source: class handouts
@Model
final class Message: Identifiable {
    var id: UUID
    var role: String
    var content: String
    var chat: Chat?
    var timestamp: Date?
    
    init(role: String, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.timestamp = Date()
    }
    
//    init(role: String, content: String, chat:Chat) {
//        self.id = UUID()
//        self.role = role
//        self.content = content
//        self.timestamp = Date()
//        self.chat = chat
//    }
}
