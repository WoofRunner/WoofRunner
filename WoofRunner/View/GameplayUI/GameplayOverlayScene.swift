//
//  GameplayOverlayScene.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

class GameplayOverlayScene: SKScene {
    
    private var scoreLabel: SKLabelNode!
    private var menuButton: SKSpriteNode!
    private var menuOverlay: SKSpriteNode!
    
    private var viewportSize: CGSize = CGSize()
    
    override init(size: CGSize) {
        super.init(size: size)
        viewportSize = size
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Update functions
    public func updateScore(_ newScore: Float) {
        scoreLabel.text = String(newScore)
    }
    
    // Helper functions
    private func didLoad() {
        // Init view elements
        initScoreLabel()
        initMenuButton()
        initMenuOverlay()
        
        // Add view elements
        self.addChild(scoreLabel)
        self.addChild(menuButton)
    }
    
    private func initScoreLabel() {
        let scoreNode = SKLabelNode(fontNamed: "AvenirNextCondensed-DemiBold")
        scoreNode.position = CGPoint(x: size.width * 0.2, y: size.height * 0.9)
        scoreNode.text = "SCORE: 00.0%"
        scoreNode.fontSize = 48
        scoreLabel = scoreNode
    }
    
    private func initMenuButton() {
        let menuButtonTexture = SKTexture(imageNamed: "home-button")
        let menuButtonSize = CGSize(width: 60.0, height: 60.0)
        let menuButtonNode = SKSpriteNode(texture: menuButtonTexture, size: menuButtonSize)
        menuButtonNode.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        menuButton = menuButtonNode
    }
    
    private func initMenuOverlay() {
        let blackScreenOverlay = SKSpriteNode(color: UIColor.black,
                                              size: CGSize(width: size.width, height: size.height))
        blackScreenOverlay.alpha = 0.5
        
    }
}
