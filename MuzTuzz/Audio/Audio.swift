//
//  Audio.swift
//  MuzTuzz
//
//  Created by Anton on 18.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation
import AVFoundation

class SoundsPlay{
    static let shared = SoundsPlay()
    
    var audioPlayer: AVAudioPlayer?
    var sound: AVAudioPlayer?
    
    func playSound(_ name: String,_ audioType: String){
        if let bundle = Bundle.main.path(forResource: name, ofType: audioType) {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                sound = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = sound else { return }
                audioPlayer.prepareToPlay()
                if Persistence.shared.zvuki || name.elementsEqual("OnMusic") {
                audioPlayer.play()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func prepareBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.volume = 0.2
                audioPlayer.prepareToPlay()
            } catch {
                print(error)
            }
        }
    }
    
    func pauseBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.pause()
    }
    
    func resumeBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
    }
    
    func startBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.play()
    }
    
}
