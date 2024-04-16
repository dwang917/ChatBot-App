//
//  InputView.swift
//  ChatBot
//
//  Created by Daming Wang on 4/14/24.
//

import SwiftUI

struct InputView: View {
    @Binding var dataModel: DataModel
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        VStack {
            TextField("Type your prompt here...", text: $dataModel.prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputActive)
                .padding()
            
            HStack {
                Button(dataModel.audioController.isRecording ? "Stop Recording" : "Start Recording") {
                    Task {
                        await dataModel.toggleRecording()
                        isInputActive = false
                    }
                }
                .keyboardShortcut(KeyEquivalent(" "), modifiers: [])
                .padding()
                
                Button("Submit") {
                    Task {
                        await dataModel.submitPrompt()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .padding()
            }
            .background(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                isInputActive = false
            }
        }
        .background(Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            isInputActive = false
        }
    }
}

//#Preview {
//    InputView()
//}
