//
//  AppSettings.swift
//  EchoMate
//
//  Created by Daming Wang on 5/1/24.
//

import Foundation
//source: class handouts, https://medium.com/@talhasaygili/userdefaults-in-swift-764277365d61
class AppSettings: ObservableObject {
    enum RecordingMode: String {
        case toggle = "toggle"
        case pressAndHold = "pressAndHold"
    }
    
    @Published var recordingMode: RecordingMode {
        didSet {
            UserDefaults.standard.set(recordingMode.rawValue, forKey: "RecordingMode")
        }
    }
    
    init() {
        let modeString = UserDefaults.standard.string(forKey: "RecordingMode") ?? RecordingMode.toggle.rawValue
        self.recordingMode = RecordingMode(rawValue: modeString) ?? .toggle
    }
}


