//
//  SpeechManager.swift
//  EnglishStudyCard
//
//  Created by Kenichi on R 7/11/01.
//
import AVFoundation

final class SpeechManager {
    static let shared = SpeechManager()
    private let synthesizer = AVSpeechSynthesizer()

    private init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("⚠️ AudioSession初期化失敗:", error)
        }
    }

    func speak(_ text: String) {
        DispatchQueue.main.async {
            if self.synthesizer.isSpeaking {
                self.synthesizer.stopSpeaking(at: .immediate)
            }
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.45
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            self.synthesizer.speak(utterance)
        }
    }
}
