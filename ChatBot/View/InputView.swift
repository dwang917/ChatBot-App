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
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        VStack {
            TextField("Type your prompt here...", text: $dataModel.prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isInputActive)
                .padding()
            //source https://www.appcoda.com/swiftui-checkbox/
            Toggle("Automatically send message after recording", isOn: $dataModel.autoSendMessage)
            
            HStack {
                
                if settings.recordingMode == .toggle{
                    Button(dataModel.audioController.isRecording ? "Stop Recording" : "Start Recording") {
                        Task {
                            await dataModel.toggleRecording()
                            
                            if dataModel.autoSendMessage && !dataModel.audioController.isRecording{
                                await dataModel.submitPrompt()
                            }
                            
                            isInputActive = false
                        }
                    }
                    .keyboardShortcut(KeyEquivalent(" "), modifiers: [])
                    .padding()
                } else if settings.recordingMode == .pressAndHold{
                    
                    //source: used generative AI to help me learn how to make a press and hold button, as I ddidn't find useful resources online
                    Text(dataModel.audioController.isRecording ? "Release to End" : "Hold to Record")
                        .foregroundColor(.white)
                        .padding()
                        .background(dataModel.audioController.isRecording ? Color.red : Color.gray)
                        .cornerRadius(10)
                        .padding()
                        .frame(width: 200, height: 100)
                        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { isPressing in
                            if isPressing {
                                Task{
                                    await dataModel.toggleRecording()
                                }
                            } else {
                                Task{
                                    await dataModel.toggleRecording()
                                    if dataModel.autoSendMessage && !dataModel.audioController.isRecording{
                                        await dataModel.submitPrompt()
                                    }
                                }
                            }
                        }, perform: {})
                    //                                .keyboardShortcut(" ", modifiers: [])
                }
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
