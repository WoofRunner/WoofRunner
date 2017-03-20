//
//  LevelDesignerOverlay.swift
//  WoofRunner
//
//  Created by See Loo Jane on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDesignerOverlayScene: SKScene {
	
	//var pauseNode: SKSpriteNode!
	//var scoreNode: SKLabelNode!
	//var cameraNode: SKCameraNode!
	
	var platformPaletteButton: LevelDesignerButtonSpriteNode!
	var deletePaletteButton: LevelDesignerButtonSpriteNode!
	
	var extendedMenuBackground: SKSpriteNode!
	var extendedMenuButton1: SKSpriteNode!
	
	var isExtendedMenuShowing = false
	var currentPressedButton: LevelDesignerButtonSpriteNode? // Button that is currently on TouchBegin
	
	/*
	var score = 0 {
		didSet {
			self.scoreNode.text = "Score: \(self.score)"
		}
	}
	*/
	
	override init(size: CGSize) {
		super.init(size: size)
		
		let screenSize: CGRect = UIScreen.main.bounds
		
		self.backgroundColor = UIColor.clear
		
		// Adding Palette Buttons
		platformPaletteButton = LevelDesignerButtonSpriteNode(imageNamed: "testPaletteButton")
		platformPaletteButton.position = CGPoint(x: size.width/12 + 8, y: size.height - size.height/6)
		
		deletePaletteButton = LevelDesignerButtonSpriteNode(imageNamed: "testDeletePaletteButton")
		deletePaletteButton.position = CGPoint(x: size.width/12 + 8, y: size.height - size.height/4)
		
		
		print(size.height)
		print(size.height/12)
		
		/*
		// Add cat sprite button
		let spriteSize = size.width/12
		self.pauseNode = SKSpriteNode(imageNamed: "testCat")
		self.pauseNode.size = CGSize(width: spriteSize, height: spriteSize)
		self.pauseNode.position = CGPoint(x: spriteSize + 8, y: spriteSize + 8)
		*/
		
		/*
		// Add score label
		self.scoreNode = SKLabelNode(text: "Score: 0")
		self.scoreNode.fontName = "DINAlternate-Bold"
		self.scoreNode.fontColor = UIColor.black
		self.scoreNode.fontSize = 24
		self.scoreNode.position = CGPoint(x: size.width/2, y: self.pauseNode.position.y - 9)
		*/
		
		// Camera setup
		//self.cameraNode = SKCameraNode()
		//self.camera = cameraNode
		
		// Extended Menu
		let buttonSize = size.width/6
		self.extendedMenuBackground = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: screenSize.width, height: screenSize.height))
		self.extendedMenuBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		
		self.extendedMenuButton1 = SKSpriteNode(imageNamed: "testCat")
		self.extendedMenuButton1.size = CGSize(width: buttonSize, height: buttonSize)
		extendedMenuBackground.addChild(extendedMenuButton1)
		extendedMenuBackground.alpha = 0.0
	
		self.addChild(platformPaletteButton)
		self.addChild(deletePaletteButton)
		self.addChild(extendedMenuBackground)
		
		// Initial Position of camera
		//cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		let pressAction = ButtonActions.getButtonPressAction()
		
		
		// Testing to see which button is selected
		if self.platformPaletteButton.contains(location!) {
			currentPressedButton = platformPaletteButton
		}
		
		if self.deletePaletteButton.contains(location!) {
			currentPressedButton = deletePaletteButton
		}
		
		// Run Action on selected button is exist
		if let selectedButton = currentPressedButton {
			selectedButton.run(pressAction)
		}
	}
	

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		let releaseAction = ButtonActions.getButtonReleaseAction()
		
		guard let selectedButton = currentPressedButton else {
			return
		}
		
		// Remove current selection + play action if user pans out of the button bounds
		if !selectedButton.contains(location!) {
			selectedButton.run(releaseAction)
			currentPressedButton = nil
		}
	}
	
	// Handle touch events of the scene
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		let releaseAction = ButtonActions.getButtonReleaseAction()
		let toggleExtendedMenuAction = getToggleExtendedMenuAction()
		
		// If there are any currently selected button,
		if let selectedButton = currentPressedButton {
			
			// Determining which button is tapped and its logic
			if selectedButton.contains(location!) {
				selectedButton.run(releaseAction)
				
				// If its grid button, do this
				toggleExtendedMenu(action: toggleExtendedMenuAction)
				
				
				// if delete button, do this
				
				// Remove ref to currentPressedbutton
				currentPressedButton = nil
				
				return
			}
		}
		
		
		// If not button if tapped, check if must close extended menu
		if isExtendedMenuShowing {
			toggleExtendedMenu(action: toggleExtendedMenuAction)
		}
	}
	
	func toggleExtendedMenu(action: SKAction) {
		self.extendedMenuBackground.run(action)
		self.isExtendedMenuShowing = !self.isExtendedMenuShowing
	}
	
	func getToggleExtendedMenuAction() -> SKAction {
		var fadeAction: SKAction
		
		if isExtendedMenuShowing {
			//fadeAction = SKAction.fadeOut(withDuration: 0.2)
			fadeAction = SKAction.fadeAlpha(to: 0.0, duration: 0.2)
		} else {
			//fadeAction = SKAction.fadeIn(withDuration: 0.2)
			fadeAction = SKAction.fadeAlpha(to: 0.95, duration: 0.2)
		}
		
		return fadeAction
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
