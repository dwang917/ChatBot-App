//
//  Chat.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation
import SwiftData
//source: class handouts
@Model
final class Chat: Identifiable {
    //timestamp?
    var id: UUID
    var title: String = ""
    
    @Relationship(deleteRule: .cascade, inverse: \Message.chat)
    var messages: [Message] = []
    
    var sortedMessages: [Message] {
        return messages.sorted(by: {$0.timestamp! < $1.timestamp!})
        }
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.messages = []
    }

    func addMessage(_ message: Message) {
        print("ok")
        messages.append(message)
        print("ok2")
    }
}
