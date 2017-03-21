//
//  LevelDesignerOverlay.swift
//  WoofRunner
//
//  Created by See Loo Jane on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit


struct OverlayConstants {
	static let numberOfPaletteButtons = CGFloat(3)
	static let paletteButtonSize = CGFloat(60)
	static let paletteButtonMargin = CGFloat(15)
	
	static let paletteWidth = paletteButtonSize + (2 * paletteButtonMargin)
	static let paletteHeight = (paletteButtonSize * numberOfPaletteButtons) + ((numberOfPaletteButtons + 1) * paletteButtonMargin)
	
	// NOTE: For SKShapeNode, position (origin) = bottom/left, not center!
	static let paletteOriginX = CGFloat(60)
	static let paletteOriginY = CGFloat(650)
	
	static let paletteCenterX = paletteOriginX + paletteWidth/2
	static let paletteCenterY = paletteOriginY + paletteHeight/2
	
	static let paletteButtonX0 = paletteOriginX + paletteWidth/2 // y-coord for the topmost palette button
	static let paletteButtonY0 = (paletteOriginY + paletteHeight) - (paletteButtonSize/2 + paletteButtonMargin) // x-coord for the topmost palette button
}



class LevelDesignerOverlayScene: SKScene {
	
	//var pauseNode: SKSpriteNode!
	//var scoreNode: SKLabelNode!
	//var cameraNode: SKCameraNode!
	
	
	// Palette
	var platformPaletteButton: LevelDesignerButtonSpriteNode!
	var obstaclePaletteButton: LevelDesignerButtonSpriteNode!
	var deletePaletteButton: LevelDesignerButtonSpriteNode!
	var paletteButtonArr = [LevelDesignerButtonSpriteNode]()
	var paletteBackground: SKShapeNode!
	
	// Extended Menus
	var extendedMenuBackground: SKSpriteNode!
	var extendedMenuButton1: SKSpriteNode!
	
	// Variables to keep track of state
	var isExtendedMenuShowing = false
	var currentShowingMenuType: LevelDesignerPaletteFunctionType?
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
		
		// Creating background for Palette Buttons
		paletteBackground = CustomShapeNodes.getRoundedRectangleNode(height: OverlayConstants.paletteHeight,
		                                                             width: OverlayConstants.paletteWidth,
		                                                             radius: 25,
		                                                             backgroundColor: SKColor(red: 0, green: 0, blue: 0, alpha: 0.95))
		
		// Set palette background position
		paletteBackground.position = CGPoint(x: OverlayConstants.paletteOriginX,
		                                     y: OverlayConstants.paletteOriginY)
		self.addChild(paletteBackground)
		
		// Creating platform buttons
		platformPaletteButton = LevelDesignerButtonSpriteNode(imageNamed: "testPaletteButton", type: .platform)
		obstaclePaletteButton = LevelDesignerButtonSpriteNode(imageNamed: "testObstaclePaletteButton", type: .obstacle)
		deletePaletteButton = LevelDesignerButtonSpriteNode(imageNamed: "testDeletePaletteButton", type: .delete)
		
		// Adjusting positions for palette buttons
		paletteButtonArr = [platformPaletteButton, obstaclePaletteButton, deletePaletteButton]
		var buttonY = OverlayConstants.paletteButtonY0
		let buttonX = OverlayConstants.paletteButtonX0
		
		for button in paletteButtonArr {
			button.position = CGPoint(x: buttonX, y: buttonY)
			buttonY -= OverlayConstants.paletteButtonSize + OverlayConstants.paletteButtonMargin
			self.addChild(button)
		}
		
		// Extended Menu
		let buttonSize = size.width/6
		self.extendedMenuBackground = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: screenSize.width, height: screenSize.height))
		self.extendedMenuBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		
		// Extended Menu Buttons
		let btnX = CGFloat(-230)
		let btnY = CGFloat(180)
		self.extendedMenuButton1 = SKSpriteNode(imageNamed: "testCat")
		self.extendedMenuButton1.size = CGSize(width: buttonSize, height: buttonSize)
		self.extendedMenuButton1.position = CGPoint(x: btnX, y: btnY)
		print(self.extendedMenuButton1.position)
		
		
		// Extended Menu Labels
		let menuTitle = SKLabelNode(text: "Platforms")
		menuTitle.fontName = "AvenirNextCondensed-Bold"
		menuTitle.fontColor = UIColor.white
		menuTitle.fontSize = 40
		menuTitle.position = CGPoint(x: 0, y: 450)
		
		let subTitle1 = SKLabelNode(text: "Static")
		subTitle1.fontName = "AvenirNextCondensed-DemiBold"
		subTitle1.fontColor = UIColor.white
		subTitle1.fontSize = 30
		subTitle1.position = CGPoint(x: btnX - 35, y: btnY + 120)
		
		let buttonTitle = SKLabelNode(text: "Default")
		buttonTitle.fontName = "AvenirNextCondensed-Medium"
		buttonTitle.fontColor = UIColor.white
		buttonTitle.fontSize = 20
		buttonTitle.position = CGPoint(x: btnX, y: btnY - 110)
		
		extendedMenuBackground.addChild(extendedMenuButton1)
		extendedMenuBackground.addChild(menuTitle)
		extendedMenuBackground.addChild(subTitle1)
		extendedMenuBackground.addChild(buttonTitle)
		extendedMenuBackground.alpha = 0.0
		
		
		// Add Extended Menu First
		self.addChild(extendedMenuBackground)
		
	
		
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
		
		// Initial Position of camera
		//cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		
		
	}
	
	
	// - MARK: Init Nodes
	
	
	// - MARK: Handle Touches
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		let pressAction = ButtonActions.getButtonPressAction()
		
		for button in paletteButtonArr {
			if button.contains(location!) {
				currentPressedButton = button
				break
			}
		}
		
		/*
		// Testing to see which button is selected
		if self.platformPaletteButton.contains(location!) {
			currentPressedButton = platformPaletteButton
		}
		
		if self.deletePaletteButton.contains(location!) {
			currentPressedButton = deletePaletteButton
		}
		*/
		
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
		
		// If not button if tapped, check if must close extended menu
		if isExtendedMenuShowing {
			toggleExtendedMenu(funcType: currentShowingMenuType!, action: toggleExtendedMenuAction)
		}
		
		// If there are any currently selected button,
		guard let selectedButton = currentPressedButton else {
			return
		}
		
		// Determining which button is tapped and its logic
		if selectedButton.contains(location!) {
			selectedButton.run(releaseAction)
			
			switch (selectedButton.type) {
				case .platform:
					toggleExtendedMenu(funcType: selectedButton.type, action: toggleExtendedMenuAction)
					currentShowingMenuType = selectedButton.type
				
				case .obstacle:
					toggleExtendedMenu(funcType: selectedButton.type, action: toggleExtendedMenuAction)
					currentShowingMenuType = selectedButton.type
				
				case .delete:
					updateCurrentSelectionView(funcType: selectedButton.type)
				
				default:
					// Do nothing
					break
			}
			
			// Remove ref to currentPressedbutton
			currentPressedButton = nil
			
			return
		}
	}
	
	func toggleExtendedMenu(funcType: LevelDesignerPaletteFunctionType, action: SKAction) {
		// Check type first
		
		// Run Action to fade in/out selected menu
		self.extendedMenuBackground.run(action)
		
		// Toggle boolean
		self.isExtendedMenuShowing = !self.isExtendedMenuShowing
	}
	
	func updateCurrentSelectionView(funcType: LevelDesignerPaletteFunctionType) {
		print("Updated Current Selection Type to: \(funcType)")
	}
	
	func getToggleExtendedMenuAction() -> SKAction {
		var fadeAction: SKAction
		
		if isExtendedMenuShowing {
			//fadeAction = SKAction.fadeOut(withDuration: 0.2)
			fadeAction = SKAction.fadeAlpha(to: 0.0, duration: 0.2)
		} else {
			//fadeAction = SKAction.fadeIn(withDuration: 0.2)
			fadeAction = SKAction.fadeAlpha(to: 0.98, duration: 0.2)
		}
		return fadeAction
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
