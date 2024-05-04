//
//  AudioRecorder.swift
//  ChatBot
//
//  Created by Daming Wang on 4/13/24.
//

import Foundation
import AVFoundation
//source: https://www.hackingwithswift.com/example-code/media/how-to-record-audio-using-avaudiorecorder
//https://stackoverflow.com/questions/26472747/recording-audio-in-swift
@Observable
class AudioController {
    private var audioRecorder: AVAudioRecorder?
    var isRecording = false
    var audioFileURL: URL? {
        return audioRecorder?.url
    }

    init() {
        setupRecorder()
    }
    

    private func setupRecorder() {
        let fileManager = FileManager.default
        let docsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = docsDir.appendingPathComponent("recordedAudio.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("Audio Recorder setup error: \(error)")
        }
    }

    func startRecording() {
        audioRecorder?.record()
        isRecording = true
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
}
