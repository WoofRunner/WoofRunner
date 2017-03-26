//
//  LevelDesignerOverlay.swift
//  WoofRunner
//
//  Created by See Loo Jane on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit
import RxSwift
import RxCocoa

class LevelDesignerOverlayScene: SKScene, PaletteButtonDelegate, OverlayButtonDelegate {
	
	var paletteMenu = PaletteMenu()
	var overlayMenu = OverlayMenu()
	var currentSelectionUI = CurrentSelectionNode()
	
	var currentTileSelection = Variable<TileType>(.floor) // Default selection. Wrap this in RXSwift
	
	//var oldOverlayY = CGFloat(0)
	var oldY = CGFloat(0)
	
	override init(size: CGSize) {
		super.init(size: size)
		self.backgroundColor = UIColor.clear
		
		// Palette
		self.paletteMenu.renderPaletteMenu()
		self.paletteMenu.assignDelegateForButtons(self)
		self.addChild(paletteMenu)
		
		// Overlay
		self.overlayMenu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		self.overlayMenu.alpha = 0.0
		self.addChild(overlayMenu)
		
		// Current Selection
		let currentSelectionPosX = CGFloat(690)
		let currentSelectionPosY = CGFloat(880)
		self.addChild(currentSelectionUI)
		self.currentSelectionUI.position = CGPoint(x: currentSelectionPosX, y: currentSelectionPosY)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		// Save y-pos of touch for calculating offset of scrolling if needed
		self.oldY = (location?.y)!
		
		let node = self.atPoint(location!)
		
		if let paletteBtnNode = node as? PaletteButton {
			paletteBtnNode.onTap()
			return
		}
		
		if let overlayBtnNode = node as? OverlayButton {
			overlayBtnNode.onTap()
			return
		}

		
	}

	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		// If Menu is visible
		if overlayMenu.alpha > 0 {
			let offset = (location?.y)! - oldY
			self.overlayMenu.scrollMenu(offset: offset)
			self.oldY = (location?.y)!
		}
	}
	
	// PaletteButtonDelegate
	internal func openOverlayMenu(_ funcType: PaletteFunctionType) {
		self.overlayMenu.renderOverlayMenu(type: funcType, delegate: self)
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.98, duration: 0.2))
	}
	
	
	// OverlayButtonDelegate
	internal func setCurrentTileSelection(_ type: TileType) {
		self.currentTileSelection.value = type
		self.currentSelectionUI.updateSelectionText(type.toString())
	}
	
	internal func closeOverlayMenu() {
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.0, duration: 0.2))
	}

}
	//var pauseNode: SKSpriteNode!
	//var scoreNode: SKLabelNode!
	//var cameraNode: SKCameraNode!
	
	/*
	
	// Palette
	var platformPaletteButton: LevelDesignerButtonSpriteNode!
	var obstaclePaletteButton: LevelDesignerButtonSpriteNode!
	var deletePaletteButton: LevelDesignerButtonSpriteNode!
	var paletteButtonArr = [LevelDesignerButtonSpriteNode]()
	var paletteBackground: SKShapeNode!
	
	// Current Selection
	var currentSelectionHeaderLabel1: SKLabelNode!
	var currentSelectionHeaderLabel2: SKLabelNode!
	var currentSelectionLabel: SKLabelNode! // Temp, for debug version only
	//var currentSelectionSprite: LevelDesignerButtonSpriteNode!
	
	// Extended Menus
	var extendedMenuBackground: SKSpriteNode!
	var extendedMenuButton1: SKSpriteNode!
	
	// BottomBar
	var bottomBarMenuBackground: SKSpriteNode!
	//var backButton: LevelDesignerButtonSpriteNode!
	//var saveButton: LevelDesignerButtonSpriteNode!
	//var levelNameLabel: SKLabelNode!
	
	// Variables to keep track of state
	var isExtendedMenuShowing = false
	var currentShowingMenuType: LevelDesignerPaletteFunctionType?
	var currentPressedButton: LevelDesignerButtonSpriteNode? // Palette Button that is currently on TouchBegin
	var currentSelectedExtendedMenuButton: LevelDesignerButtonSpriteNode? // Currently selected block
	
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
		
		//******* Palette **********//
		
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
		
		//*********** Current Selection UI ************//
		
		// Current Selection UI
		let headerPosX = CGFloat(690)
		let headerPosY = CGFloat(880)
		currentSelectionHeaderLabel1 = SKLabelNode(text: "Current")
		currentSelectionHeaderLabel1.fontName = "AvenirNextCondensed-Bold"
		currentSelectionHeaderLabel1.fontColor = UIColor.black
		currentSelectionHeaderLabel1.fontSize = 25
		currentSelectionHeaderLabel1.position = CGPoint(x: headerPosX, y: headerPosY)
		
		currentSelectionHeaderLabel2 = SKLabelNode(text: "Selection:")
		currentSelectionHeaderLabel2.fontName = "AvenirNextCondensed-Bold"
		currentSelectionHeaderLabel2.fontColor = UIColor.black
		currentSelectionHeaderLabel2.fontSize = 25
		currentSelectionHeaderLabel2.position = CGPoint(x: headerPosX, y: headerPosY - 25)
		
		currentSelectionLabel = SKLabelNode(text: "Test")
		currentSelectionLabel.fontName = "AvenirNextCondensed-Bold"
		currentSelectionLabel.fontColor = UIColor.blue
		currentSelectionLabel.fontSize = 20
		currentSelectionLabel.position = CGPoint(x: headerPosX, y: headerPosY - 60)
		
		self.addChild(currentSelectionHeaderLabel1)
		self.addChild(currentSelectionHeaderLabel2)
		self.addChild(currentSelectionLabel)
		
		//************ Extended Menu *************//
		
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
		
		//************* Bottom Bar *************//
		bottomBarMenuBackground = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: screenSize.width, height: screenSize.height / 11))
		bottomBarMenuBackground.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 40)
		self.addChild(bottomBarMenuBackground)
		/*
		backButton =
		saveButton: LevelDesignerButtonSpriteNode!
		levelNameLabel: SKLabelNode!
		*/
		
		
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
		
		/*
		let hitResults = self.view?.hitTest(location!, with: event)
		hitResults?.next?.touchesBegan(touches, with: event)
		*/
		
		let pressAction = ButtonActions.getButtonPressAction()
		
		for button in paletteButtonArr {
			if button.contains(location!) {
				print("Touch Begin on Button!")
				currentPressedButton = button
				break
			}
		}
		
		// Run Action on selected button is exist
		if let selectedButton = currentPressedButton {
			print("PaletteButton begins pressed action")
			selectedButton.run(pressAction, completion: {
				print("Action completed!")
			})
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
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("Touch cancelled")
	}
	
	// Handle touch events of the scene
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		let releaseAction = ButtonActions.getButtonReleaseAction()
		let toggleExtendedMenuAction = getToggleExtendedMenuAction()
		
		// If extended Menu is open, check which selection is selected (or if nil, just close menu)
		if isExtendedMenuShowing {

			if self.atPoint(location!) == extendedMenuButton1 {
				updateCurrentSelection(selection: "Default Platform")
			}
			
			toggleExtendedMenu(funcType: currentShowingMenuType!, action: toggleExtendedMenuAction)
		}
		
		// If there are any currently selected button,
		guard let selectedButton = currentPressedButton else {
			print("Touch Ended cos selectedButton is nil")
			return
		}
		
		// Determining which button is tapped and its logic
		if selectedButton.contains(location!) {
			selectedButton.run(releaseAction)
			
			switch (selectedButton.type) {
				case .platform:
					print("Ended on Platform")
					toggleExtendedMenu(funcType: selectedButton.type, action: toggleExtendedMenuAction)
					currentShowingMenuType = selectedButton.type
				
				case .obstacle:
					print("Ended on Obstacle")
					toggleExtendedMenu(funcType: selectedButton.type, action: toggleExtendedMenuAction)
					currentShowingMenuType = selectedButton.type
				
				case .delete:
					//updateCurrentSelectionView(funcType: selectedButton.type)
					print("Ended on Delete")
					updateCurrentSelection(selection: "Delete")
				
				default:
					// Do nothing
					break
			}
			
			// Remove ref to currentPressedbutton
			currentPressedButton = nil
			
			return
		}
	}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancelled")
    }
	
	func toggleExtendedMenu(funcType: LevelDesignerPaletteFunctionType, action: SKAction) {
		// Check type first
		
		// Run Action to fade in/out selected menu
		self.extendedMenuBackground.run(action)
		
		// Toggle boolean
		self.isExtendedMenuShowing = !self.isExtendedMenuShowing
	}
	
	/*
	func updateCurrentSelectionView(funcType: LevelDesignerPaletteFunctionType) {
		//print("Updated Current Selection Type to: \(funcType)")
	}
	*/
	
	
	// Trigger LevelDesigner to inform logic
	func updateCurrentSelection(selection: String) {
		currentSelectionLabel.text = selection
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
*/
