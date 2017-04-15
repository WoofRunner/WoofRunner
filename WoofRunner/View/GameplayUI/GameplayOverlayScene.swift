//
//  GameplayOverlayScene.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

/**
Shown during Gameplay and in charge of rendering and showing the
game win/lose menus.
*/
class GameplayOverlayScene: SKScene, GameplayOverlayButtonDelegate {
	
	typealias Constants = GameplayOverlayConstants
	
	// MARK: - Private Variables
	
    private var menuButton: SKSpriteNode!
    private var menuOverlay: SKNode!
	
	// Child Nodes to be attached to menuOverlay
	private var pauseMenu = SKSpriteNode(imageNamed: Constants.pauseMenuBG)
	private var winMenu = SKSpriteNode(imageNamed: Constants.winMenuBG)
	private var loseMenu = SKSpriteNode(imageNamed: Constants.loseMenuBG)
	
    private var viewportSize: CGSize = CGSize()
	private var overlayDelegate: GameplayOverlayDelegate?
	private var currentlyShowingMenu: SKNode?
	
	// MARK: - Initialisers
	
    override init(size: CGSize) {
        super.init(size: size)
        viewportSize = size
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	
	// MARK: - View Init Helper Methods
	
	private func didLoad() {
		initMenuButton()
		initMenuOverlay()
		initPauseMenu()
		initGameEndMenu(menu: winMenu)
		initGameEndMenu(menu: loseMenu)
		
		// Add view elements
		self.addChild(menuButton)
		self.addChild(menuOverlay)
	}
	
    private func initMenuButton() {
        let menuButtonTexture = Constants.menuButtonSprite
        let menuButtonSize = Constants.menuButtonSize
        let menuButtonNode = SKSpriteNode(texture: menuButtonTexture, size: menuButtonSize)
		menuButtonNode.position = CGPoint(x: size.width * Constants.menuButtonXPosScale,
		                                  y: size.height * Constants.menuButtonYPosScale)
        menuButton = menuButtonNode
    }
    
    private func initMenuOverlay() {
		
		// Init MenuOverlay Parent Node
		menuOverlay = SKNode()
		menuOverlay.position = CGPoint(x: size.width * Constants.overlayXPosScale,
		                               y: size.height * Constants.overlayYPosScale)
		menuOverlay.alpha = 0
		
		// Init and attach the black overlay
		let blackScreenOverlay = SKSpriteNode(color: Constants.overlayColor,
                                              size: CGSize(width: size.width,
                                                           height: size.height))
		menuOverlay.addChild(blackScreenOverlay)
	}
	
	private func initPauseMenu() {
		pauseMenu.size = Constants.pauseMenuSize
		
		// Init Child Views
		let resumeButton = GameplayOverlayButton(type: .resume)
		let retryButton = GameplayOverlayButton(type: .retry)
		let exitButton = GameplayOverlayButton(type: .exit)
		
		// Attach Child View Nodes
		pauseMenu.addChild(resumeButton)
		pauseMenu.addChild(retryButton)
		pauseMenu.addChild(exitButton)
		
		// Adjust Button Positions
		resumeButton.position = Constants.pResumeButtonPos
		retryButton.position = Constants.pRetryButtonPos
		exitButton.position = Constants.pExitButtonPos
		
		// Attach Delegates
		resumeButton.setDelegate(self)
		retryButton.setDelegate(self)
		exitButton.setDelegate(self)
	}
	
	private func initGameEndMenu(menu: SKSpriteNode) {
		menu.size = Constants.endMenuSize
		
		// Init Child Views
		let retryButton = GameplayOverlayButton(type: .retry)
		let exitButton = GameplayOverlayButton(type: .exit)
		
		// Attach Child View Nodes
		menu.addChild(retryButton)
		menu.addChild(exitButton)
		
		// Adjust Button Positions
		retryButton.position = Constants.eRetryButtonPos
		exitButton.position = Constants.eExitButtonPos
		
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
	
	private func showOverlayMenu(_ menu: SKNode) {
		menuOverlay.addChild(menu)
		currentlyShowingMenu = menu
		self.menuOverlay.alpha = 1.0
	}
	
	private func showPauseMenu() {
		showOverlayMenu(pauseMenu)
	}
	
	
	private func hideOverlayMenu() {
		self.menuOverlay.alpha = 0.0
		currentlyShowingMenu?.removeFromParent()
		currentlyShowingMenu = nil
	}
	
	// MARK: - Public Methods
	
	/**
	Displays the winning menu screen.
	*/
	 public func showWinMenu() {
		// If winMenu already has a parent, do not assign another parent to it
		if let _ = winMenu.parent {
			return
		}
		showOverlayMenu(winMenu)
	}
	
	/**
	Displays the losing menu screen
	*/
	public func showLoseMenu() {
		// If loseMenu already has a parent, do not assign another parent to it
		if let _ = loseMenu.parent {
			return
		}
		showOverlayMenu(loseMenu)
	}

	/**
	Sets the GameplayOverlayDelegate for this scene.
	*/
	public func setDelegate(_ delegate: GameplayOverlayDelegate) {
		self.overlayDelegate = delegate
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
