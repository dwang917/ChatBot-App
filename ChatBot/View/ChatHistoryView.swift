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
    @State private var selectedChats: Set<UUID> = []
    
    var body: some View {
        NavigationStack{
            List(selection: $selectedChats) {
                ForEach(chats, id: \.id) { chat in
                    HStack {
                        TextField("Title", text: Binding(
                            get: { chat.title },
                            set: { newTitle in
                                chat.title = newTitle
                            }
                        ))
                        .textFieldStyle(PlainTextFieldStyle())
                    }.padding()
                }
            }
            //source https://developer.apple.com/documentation/swiftui/view/toolbar(content:)-5w0tj
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {dataModel.addNewChat()}) {
                        Label("Add Chat", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigation) {
                    Button(action: deleteSelectedChats) {
                        Label("Delete Selected", systemImage: "trash")
                    }
                    .disabled(selectedChats.isEmpty)
                }
                ToolbarItem(placement: .navigation) {
                    Button(action: switchChat) {
                        Label("Open Selected", systemImage: "envelope.open")
                    }
                    .disabled(selectedChats.isEmpty || selectedChats.count > 1)
                }
            }
            .navigationTitle("Chats")
        }
        
        
    }
    
    private func switchChat() {
        if let selectedChat = chats.first(where: { $0.id == selectedChats.first}){
            dataModel.switchChat(to: selectedChat)
        }
    }
    
    private func deleteSelectedChats() {
        selectedChats.forEach { id in
            if let chatToDelete = chats.first(where: { $0.id == id }) {
                dataModel.deleteChat(chatToDelete)
            }
        }
        selectedChats.removeAll()  // Clear selection after deletion
    }
}

//#Preview {
//    ChatHistoryView()
//}
