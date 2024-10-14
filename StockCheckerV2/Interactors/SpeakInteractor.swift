//
//  SpeakInteractor.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 02/10/2022.
//

import AVFoundation

final class SpeakInteractor {
    private static let synthesizer = AVSpeechSynthesizer()
    func speak(_ value: String) {
        guard !UserDefaults.standard.bool(forKey: SoundDistanceView.soundOffKey) else { return }
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, options: .mixWithOthers)
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        Self.synthesizer.speak(utterance)
    }

    func stop() {
        Self.synthesizer.stopSpeaking(at: .immediate)
    }
}
