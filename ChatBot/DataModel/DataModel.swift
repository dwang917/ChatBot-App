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
    
    init() {
        self.autoSendMessage = UserDefaults.standard.bool(forKey: "AutoSendMessage")
    }
    
    
    var requestBody = RequestBody(messages: [APIMessage(role: "system", content: "You are a helpful assistant.")], model: "gpt-3.5-turbo")
    
    func submitPrompt() async {
        guard let localModelContext = modelContext else {return}
        
        let userMessage = APIMessage(role: "user", content: prompt)
        
        let message = Message(role: "user", content: prompt)
        
        if currentChat.messages.isEmpty {
            currentChat.title = prompt
            currentChat.addMessage(message)
            localModelContext.insert(currentChat)
        } else {
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
            currentChat.addMessage(Message(role: systemMessage.role, content: systemMessage.content))
            
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
            print(resultString)
            prompt = resultString
        } catch {
            print("sending Audio went wrong")
        }
    }
    
    func deleteChat(_ chat: Chat) {
        guard let localModelContext = modelContext else {return}
        if chat == currentChat {
            currentChat = Chat(title: "default")
        }
        localModelContext.delete(chat)
    }
}
