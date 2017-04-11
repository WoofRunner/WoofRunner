//
//  SceneKitExtensions.swift
//  WoofRunner
//
//
// Creates an audioManager for the sound asset in the specified path.
// If no asset is found, the manager will not perform any sound playback functions
// - parameter path: url to the sound asset
//
//  Created by See Soon Kiat on 6/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import AVFoundation

class AVAudioPlayerManager {
    
    private var audioPlayer: AVAudioPlayer?
    private var fadeIn = false;
    
    init(path: String) {
        guard let path = Bundle.main.path(forResource: path, ofType: nil) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer = audioPlayer
        } catch {
            print("No such audio found")
        }
    }
    
    /**
     Specify the number of times the audio will loop for when playing
     Specifying -1 will loop the audio forever
     - parameter loop: number of times audio will loop
     */
    public func setLoop(_ loop: Int) {
        guard let sound = audioPlayer else {
            return
        }
        sound.numberOfLoops = loop
    }
    
    /**
     Plays the audio from the start
     */
    public func playFromStart() {
        guard let sound = audioPlayer else {
            return
        }
        sound.stop()
        sound.play()
    }
    
    /**
     Plays the audio from the last stopped point
     */
    public func play() {
        guard let sound = audioPlayer else {
            return
        }
        sound.play()
    }
    
    /**
     Pause the audio from from playing
     */
    public func pause() {
        guard let sound = audioPlayer else {
            return
        }
        sound.pause()
    }
    
    /**
     Stops the audio playback and undoes the setup to resume
     */
    public func stop() {
        guard let sound = audioPlayer else {
            return
        }
        sound.stop()
    }
    
    /**
     Start to fade out the background music
     - parameter duration: In seconds
     */
    public func startFadeOut(duration: Float) {
        fadeIn = false
        let fadeOutBy = 0.1 / duration
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(100)) {
            self.fade(fadeOutBy)
        }
    }
    
    /**
     Start to fade in the background music
      -parameter duration: In seconds
     */
    public func startFadeIn(duration: Float) {
        fadeIn = true
        let fadeInBy = 0.1 / duration
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(100)) {
            self.fade(fadeInBy)
        }
    }
    
    private func fade(_ fadeBy: Float) {
        guard let sound = audioPlayer else {
            return
        }
        
        // Use a lock to prevent infinite async calls
        if (fadeIn) {
            sound.volume += fadeBy
        } else {
            sound.volume -= fadeBy
        }
        
        if (!fadeIn && sound.volume > 0) || (fadeIn && sound.volume < 1) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(100)) {
                self.fade(fadeBy)
            }
        } else if (!fadeIn) {
            sound.volume = 0.0
            
        } else if (fadeIn) {
            sound.volume = 1.0
        }
    }
}
