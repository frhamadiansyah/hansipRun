//
//  GameScene+ExtensionSound.swift
//  hansipRun
//
//  Created by Haddawi on 15/06/20.
//  Copyright © 2020 Fandrian Rhamadiansyah. All rights reserved.
//

import Foundation
import AVFoundation

extension GameScene {
    func setupBackSongAudio() {
        let sound = Bundle.main.path(forResource: "//juhani-junkala-adventure-backsong", ofType: "wav")
        
        do {
            backsongAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print(error)
        }
        
        backsongAudio.play()
    }
    
    func removeBackSong() {
        backsongAudio.stop()
    }
    
    func setupJumpEffectAudio() {
        let jumpSound = Bundle.main.path(forResource: "jump-effect", ofType: "wav")
        
        do {
            jumpAudio = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: jumpSound!))
        } catch {
            print(error)
        }
    }
}
