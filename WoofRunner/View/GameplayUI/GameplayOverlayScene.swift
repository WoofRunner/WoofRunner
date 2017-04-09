//
//  GameplayOverlayScene.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

class GameplayOverlayScene: SKScene, GameplayOverlayButtonDelegate {
    
    private var scoreLabel: SKLabelNode!
    private var menuButton: SKSpriteNode!
    private var menuOverlay: SKNode!
    
    private var viewportSize: CGSize = CGSize()
	
	private var overlayDelegate: GameplayOverlayDelegate?
    
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
	
	public func setDelegate(_ delegate: GameplayOverlayDelegate) {
		self.overlayDelegate = delegate
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
		self.addChild(menuOverlay)
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		let node = self.atPoint(location!) as SKNode
		
		if node == menuButton {
			handleMenuTap()
			return
		}
		
		if let btn = node as? GameplayOverlayButton {
			btn.onTap()
			return
		}
	}
	
    private func initScoreLabel() {
        let scoreNode = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
        scoreNode.position = CGPoint(x: size.width * 0.9, y: size.height * 0.9)
        scoreNode.text = "0 %"
        scoreNode.fontSize = 48
        scoreLabel = scoreNode
    }
    
    private func initMenuButton() {
        let menuButtonTexture = SKTexture(imageNamed: "pause-button")
        let menuButtonSize = CGSize(width: 60.0, height: 60.0)
        let menuButtonNode = SKSpriteNode(texture: menuButtonTexture, size: menuButtonSize)
		menuButtonNode.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        menuButton = menuButtonNode
    }
    
    private func initMenuOverlay() {
		
		// Init MenuOverlay Parent Node
		menuOverlay = SKNode()
		menuOverlay.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
		menuOverlay.alpha = 0
		
		// Init Child View Nodes
		let blackScreenOverlay = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8),
                                              size: CGSize(width: size.width, height: size.height))
		let pauseMenu = SKSpriteNode(imageNamed: "pause-menu-bg")
		pauseMenu.size = CGSize(width: 500, height: 500)
		let resumeButton = GameplayOverlayButton(imageNamed: "resume-button", type: .resume)
		let retryButton = GameplayOverlayButton(imageNamed: "retry-button", type: .retry)
		let exitButton = GameplayOverlayButton(imageNamed: "exit-pause-button", type: .exit)
		
		// Attach Child View Nodes
		menuOverlay.addChild(blackScreenOverlay)
		menuOverlay.addChild(pauseMenu)
		pauseMenu.addChild(resumeButton)
		pauseMenu.addChild(retryButton)
		pauseMenu.addChild(exitButton)
		
		// Adjust Button Positions
		resumeButton.position = CGPoint(x: 0,
		                                y: pauseMenu.size.height / 3 - 60)
		retryButton.position = CGPoint(x: 0,
		                                y: pauseMenu.size.height / 3 - 160)
		exitButton.position = CGPoint(x: 0,
		                                y: pauseMenu.size.height / 3 - 260)
		
		// Attach delegates to buttons
		resumeButton.setDelegate(self)
		retryButton.setDelegate(self)
		exitButton.setDelegate(self)
	}
	
	
	
	private func handleMenuTap() {
		menuButton.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			self.showPauseMenu()
			self.overlayDelegate?.pauseGame()
		})
	}
	
	private func showPauseMenu() {
		self.menuOverlay.alpha = 1.0
	}
	
	private func hidePauseMenu() {
		self.menuOverlay.alpha = 0.0
	}
	
	// MARK: - GameplayOverlayButtonDelegate 
	
	internal func handleButtonTap(_ type: GameplayOverlayButtonType) {
		switch type {
		case .resume :
			hidePauseMenu()
			self.overlayDelegate?.resumeGame()
		case .retry :
			self.overlayDelegate?.retryGame()
		case .exit :
			self.overlayDelegate?.exitGame()
		}
	}
}
