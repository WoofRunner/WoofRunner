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
	
	// Child Nodes to be attached to menuOverlay
	private var pauseMenu = SKSpriteNode(imageNamed: "pause-menu-bg")
	private var winMenu = SKSpriteNode(imageNamed: "win-menu-bg")
	private var loseMenu = SKSpriteNode(imageNamed: "lose-menu-bg")
	
    private var viewportSize: CGSize = CGSize()
	
	private var overlayDelegate: GameplayOverlayDelegate?
	
	private var currentlyShowingMenu: SKNode?
    
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
		initPauseMenu()
		initGameEndMenu(menu: winMenu)
		initGameEndMenu(menu: loseMenu)
        
        // Add view elements
        //self.addChild(scoreLabel)
        //self.addChild(menuButton)
		self.addChild(menuOverlay)
    }
	
	
	// MARK: - View Init Helper Methods
	
    private func initScoreLabel() {
        let scoreNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
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
		
		// Init and attach the black overlay
		let blackScreenOverlay = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8),
                                              size: CGSize(width: size.width, height: size.height))
		menuOverlay.addChild(blackScreenOverlay)
	}
	
	private func initPauseMenu() {
		pauseMenu.size = CGSize(width: 500, height: 500)
		
		// Init Child Views
		let resumeButton = GameplayOverlayButton(type: .resume)
		let retryButton = GameplayOverlayButton(type: .retry)
		let exitButton = GameplayOverlayButton(type: .exit)
		
		// Attach Child View Nodes
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
		
		// Attach Delegates
		resumeButton.setDelegate(self)
		retryButton.setDelegate(self)
		exitButton.setDelegate(self)
	}
	
	private func initGameEndMenu(menu: SKSpriteNode) {
		menu.size = CGSize(width: 500, height: 500)
		
		// Init Child Views
		let finalScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
		finalScoreLabel.fontSize = 40
		finalScoreLabel.text = scoreLabel.text
		let retryButton = GameplayOverlayButton(type: .retry)
		let exitButton = GameplayOverlayButton(type: .exit)
		
		// Attach Child View Nodes
		//menu.addChild(finalScoreLabel)
		menu.addChild(retryButton)
		menu.addChild(exitButton)
		
		// Adjust Button Positions
		/* UNUSED AT THE MOMENT BECAUSE TEMPORARILY REMOVING SCORE LABEL
		finalScoreLabel.position = CGPoint(x: 0,
		                                   y: menu.size.height / 3 - 80)
		retryButton.position = CGPoint(x: 0,
		                               y: menu.size.height / 3 - 180)
		exitButton.position = CGPoint(x: 0,
		                              y: menu.size.height / 3 - 260)
		*/
		
		retryButton.position = CGPoint(x: 0,
		                               y: menu.size.height / 3 - 130)
		exitButton.position = CGPoint(x: 0,
		                              y: menu.size.height / 3 - 210)
		
		// Attach Delegates
		retryButton.setDelegate(self)
		exitButton.setDelegate(self)
	
	}
	
	// MARK: - Tap Handlers
	
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
	
	private func handleMenuTap() {
		menuButton.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			self.showPauseMenu()
			self.overlayDelegate?.pauseGame()
		})
	}
	
	// MARK: - Menu Toggles
	
	private func showPauseMenu() {
		menuOverlay.addChild(pauseMenu)
		currentlyShowingMenu = pauseMenu
		self.menuOverlay.alpha = 1.0
		
	}
	
	private func hideOverlayMenu() {
		self.menuOverlay.alpha = 0.0
		currentlyShowingMenu?.removeFromParent()
		currentlyShowingMenu = nil
	}
	
	// Public functions to display menu so as can be called from View Controller
	// NOTE: Have to check for parent before childNode's addChild because method is repeatedly
	// called from the GameController every frame
	 public func showWinMenu() {
		// If winMenu already has a parent, do not repeat method
		if let _ = winMenu.parent {
			return
		}
		
		menuOverlay.addChild(winMenu)
		currentlyShowingMenu = winMenu
		self.menuOverlay.alpha = 1.0
	}
	
	public func showLoseMenu() {
		// If loseMenu already has a parent, do not repeat method
		if let _ = loseMenu.parent {
			return
		}
		
		menuOverlay.addChild(loseMenu)
		currentlyShowingMenu = loseMenu
		self.menuOverlay.alpha = 1.0
	}
	
	
	
	// MARK: - GameplayOverlayButtonDelegate 
	
	internal func handleButtonTap(_ type: GameplayOverlayButtonType) {
		switch type {
		case .resume :
			hideOverlayMenu()
			self.overlayDelegate?.resumeGame()
		case .retry :
			hideOverlayMenu()
			self.overlayDelegate?.retryGame()
		case .exit :
			self.overlayDelegate?.exitGame()
		}
	}
}
