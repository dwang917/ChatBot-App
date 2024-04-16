//
//  Message.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation
import SwiftData

@Model
final class Message: Identifiable {
    var id: UUID
    var role: String
    var content: String
    var chat: Chat?
    
    init(role: String, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
    }
}
