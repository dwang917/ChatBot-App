//
//  DataModel.swift
//  ChatBot
//
//  Created by Daming Wang on 4/9/24.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class DataModel {
    
    var prompt: String = "Hello there"
    var conversation: [APIMessage] = []
    var currentChat: Chat = Chat(title: "default")
    var pressAndHold: Bool = false
    var autoSendMessage: Bool = false {
        didSet {
            UserDefaults.standard.set(autoSendMessage, forKey: "AutoSendMessage")
        }
    }
    
    let networkManager = NetworkManager.shared
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let audioController = AudioController()
    var modelContext: ModelContext?
    
    var requestBody = RequestBody(messages: [APIMessage(role: "system", content: "You are a helpful assistant.")], model: "gpt-3.5-turbo")
    
    init() {
        self.autoSendMessage = UserDefaults.standard.bool(forKey: "AutoSendMessage")
    }
    
    
    
    
    
    func submitPrompt() async {
        guard let localModelContext = modelContext else {return}
        
        let userMessage = APIMessage(role: "user", content: prompt)
        
        let message = Message(role: "user", content: prompt)
        
        if currentChat.title == "default" {
            currentChat.title = prompt
            currentChat.addMessage(message)
            localModelContext.insert(currentChat)
        }
        
        else if currentChat.title == "New Chat" {
            currentChat.title = prompt
            currentChat.addMessage(message)
        }
        
        else{
            currentChat.addMessage(message)
        }
        
        requestBody.messages.append(userMessage)
        conversation.append(userMessage)
        prompt = ""
        do {
            let jsonData = try encoder.encode(requestBody)
            let responseData = try await networkManager.fetchData(with: jsonData)
        
            
            let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
            let systemMessage = apiResponse.choices[0].message
            conversation.append(systemMessage)
            let responseMessage = Message(role: "system", content: systemMessage.content)
            currentChat.addMessage(responseMessage)

            requestBody.messages.append(systemMessage)
        } catch {
            print("Failed to encode request: \(error)")
        }
    }
    
    func toggleRecording() async {
        if audioController.isRecording {
            audioController.stopRecording()
            await submitAudio()
        } else {
            audioController.startRecording()
        }
    }
    
    private func submitAudio() async{
        guard let audioURL = audioController.audioFileURL else { return }
        do {
            let resultString = try await networkManager.fetchAudioData(with: audioURL)

            prompt = resultString
        } catch {
            print("sending Audio went wrong")
        }
    }
    
    
    
    func deleteChat(_ chat: Chat) {
        guard let localModelContext = modelContext else {return}
        
        if chat == currentChat {
            localModelContext.delete(chat)
            prompt = "Hello there"
            conversation = []
            currentChat = Chat(title: "default")
            requestBody = RequestBody(messages: [APIMessage(role: "system", content: "You are a helpful assistant.")], model: "gpt-3.5-turbo")
        } else{
            localModelContext.delete(chat)
        }
    }
    
    func addNewChat() {
        guard let localModelContext = modelContext else {return}
        localModelContext.insert(Chat(title: "New Chat"))
    }
    
    
    
    func switchChat(to selectedChat: Chat) {
        currentChat = selectedChat
        convertMessagesToConversation(messages: selectedChat.sortedMessages)
        switchRequestBody()
        
    }
    
    private func convertMessagesToConversation(messages: [Message]) {
        conversation = []
        for message in messages {
            conversation.append(APIMessage(role: message.role, content: message.content))
        }
    }
    
    private func switchRequestBody(){
        requestBody = RequestBody(messages: [APIMessage(role: "system", content: "You are a helpful assistant.")], model: "gpt-3.5-turbo")
        
        for message in conversation {
            requestBody.messages.append(message)
        }
    }
}
