//
//  SceneKitExtensions.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 6/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit
import SpriteKit

extension SCNAudioSource {
    convenience init(name: String, volume: Float = 1.0, positional: Bool = true, loops: Bool = false, shouldStream: Bool = false, shouldLoad: Bool = true) {
        self.init(named: "game.scnassets/sounds/\(name)")!
        self.volume = volume
        self.isPositional = positional
        self.loops = loops
        self.shouldStream = shouldStream
        if shouldLoad {
            load()
        }
    }
    
    /* Example
     let exampleSound = SCNAudioSource(name: "example_sound.mp3", volume: 2.0)
     let exampleNode = SCNNode()
     exampleNode.runAction(SCNAction.playAudio(exampleSound, waitForCompletion: false))
     */
}
