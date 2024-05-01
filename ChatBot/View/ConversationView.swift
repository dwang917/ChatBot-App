//
//  ConversationView.swift
//  ChatBot
//
//  Created by Daming Wang on 4/14/24.
//

import SwiftUI

struct ConversationView: View {
    var conversationList: [APIMessage]
    var chat: Chat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(conversationList, id: \.self) { message in
                    VStack(alignment: .center) {
//                        TextEditor(text: $message.content.trimmingCharacters(in: .newlines))
                        Text(message.content.trimmingCharacters(in: .newlines))
                            .font(message.role == "user" ? .none : .title3.bold().italic())
                    }.padding()
                    
                    Divider()
                }
                
//                ForEach(chat.messages) { message in
//                    VStack(alignment: .center) {
////                        TextEditor(text: $message.content.trimmingCharacters(in: .newlines))
//                        Text(message.content.trimmingCharacters(in: .newlines))
//                            .font(message.role == "user" ? .none : .title3.bold().italic())
//                    }.padding()
//                    
//                    Divider()
//                }
            }
        }
    }
}

//#Preview {
//    ConversationView()
//}
