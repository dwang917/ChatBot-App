//
//  ChatBotApp.swift
//  ChatBot
//
//  Created by Daming Wang on 4/8/24.
//

import SwiftUI
import SwiftData

@main
struct ChatBotApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Chat.self,
            Message.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
        .modelContainer(sharedModelContainer)
        //source: https://swiftwithmajid.com/2020/11/24/commands-in-swiftui/
        .commands {
            CommandMenu("Recording Options") {
                Picker("Recording Mode", selection: $settings.recordingMode) {
                    Text("Toggle to record").tag(AppSettings.RecordingMode.toggle)
                    Text("Press and hold to record").tag(AppSettings.RecordingMode.pressAndHold)
                }
                .pickerStyle(.inline)
            }
        }
    }
}
