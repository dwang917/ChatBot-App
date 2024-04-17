//
//  ChatHistoryView.swift
//  ChatBot
//
//  Created by Daming Wang on 4/15/24.
//

import SwiftUI
import SwiftData

struct ChatHistoryView: View {
    var chats: [Chat]
    
    var body: some View {
        VStack {
            ForEach(chats) { chat in
                VStack {
                    Text(chat.title)
                }.padding()
                Divider()
            }
        }
    }
}

//#Preview {
//    ChatHistoryView()
//}
