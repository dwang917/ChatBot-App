//
//  Chat.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation
import SwiftData

@Model
final class Chat: Identifiable {
    //timestamp?
    var id: UUID
    var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \Message.chat)
    var messages: [Message]
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.messages = []
    }

    func addMessage(_ message: Message) {
        messages.append(message)
    }
}
