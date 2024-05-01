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
    var dataModel: DataModel
    
    var body: some View {
        VStack {
            ForEach(chats.reversed()) { chat in
                HStack {
                    Text(chat.title)
                    Button(action: {dataModel.deleteChat(chat)}, label: {
                        Image(systemName: "delete.left.fill")
                    })
                }.padding()
                Divider()
            }
        }
    }
}

//#Preview {
//    ChatHistoryView()
//}
