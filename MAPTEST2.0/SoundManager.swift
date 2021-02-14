//
//  SoundManager.swift
//  MAPTEST2.0
//
//  Created by Hugo Paja Guallar on 02.02.21.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFileName = ""
        
        switch effect {
        
        case .flip:
            soundFileName = "cardflip"
        case .shuffle:
            soundFileName = "shuffle"
        case .match:
            soundFileName = "dingcorrect"
        case .nomatch:
            soundFileName = "dingwrong"
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFileName) in the bundle")
            return
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
        }
        catch {
            print("couldn't create the audio file object for sound file \(soundFileName)")
        }
        
        }
  
    
}

