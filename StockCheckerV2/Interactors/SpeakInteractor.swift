//
//  SpeakInteractor.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 02/10/2022.
//

import AVFoundation

final class SpeakInteractor {
    private let synthesizer = AVSpeechSynthesizer()
    func speak(_ value: String) {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
