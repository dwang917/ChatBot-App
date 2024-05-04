//
//  ContentView.swift
//  ChatBot
//
//  Created by Daming Wang on 4/8/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    //TODO: update Query
    @Query var chats: [Chat]
    
    @State var dataModel = DataModel()

    var body: some View {
        HSplitView {
            ChatHistoryView(chats: chats.reversed(), dataModel: dataModel)
                .frame(minWidth: 80, maxWidth: 300, minHeight:400, maxHeight: .infinity)
            
            VSplitView {
                ConversationView(conversationList: dataModel.conversation, chat: dataModel.currentChat)
                    .frame(minWidth: 200, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
                
                InputView(dataModel: $dataModel)
                    .frame(minWidth: 300, maxWidth: .infinity, minHeight: 180, maxHeight: .infinity)
                
            }
        }
        .onAppear() {
            if dataModel.modelContext == nil {
                self.dataModel.modelContext = modelContext
            }
        }
    }
    
    
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
