//
//  SpeakInteractor.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 02/10/2022.
//

import AVFoundation

final class SpeakInteractor {

    func speak(_ value: String) {
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}
