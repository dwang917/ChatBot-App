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
    var currentChat: Chat?
    
    let networkManager = NetworkManager.shared
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let audioController = AudioController()
    var modelContext: ModelContext?
    
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        self.currentChat = Chat()
//        }
    
    
    var requestBody = RequestBody(messages: [APIMessage(role: "system", content: "You are a helpful assistant.")], model: "gpt-3.5-turbo")
    
    func submitPrompt() async {
        //guard let localModelContext = modelContext else {return}
        
        
        let userMessage = APIMessage(role: "user", content: prompt)
        requestBody.messages.append(userMessage)
        conversation.append(userMessage)
        prompt = ""
        do {
            let jsonData = try encoder.encode(requestBody)
            let responseData = try await networkManager.fetchData(with: jsonData)
        
            
            let apiResponse = try decoder.decode(APIResponse.self, from: responseData)
            let systemMessage = apiResponse.choices[0].message
            conversation.append(systemMessage)
            
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
}
