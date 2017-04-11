//
//  OverlayMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class OverlayMenu: SKNode {
	
	typealias Constants = LDOverlaySceneConstants.OverlayConstants
	
	private let backgroundNode = SKSpriteNode(texture: nil,
	                                          color: Constants.backgroundColor,
	                                          size: CGSize(width: Constants.backgroundWidth,
	                                                       height: Constants.backgroundHeight))
	private var titleNode = SKLabelNode()
	private var closeBtnNode = OverlayButton(imageNamed: Constants.closeBtnImageSprite,
	                                         tileName: nil,
	                                         size: Constants.closeBtnSize)
	private var subsectionNode = OverlayMenuSubsection()
	private var menuNode = SKNode()
	
	private var maxY = CGFloat(0) // Max y-bound of MenuNode, required for scrolling bounds
	
	// MARK: - Init Methods
	
	override init() {
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Method
	
	// Renders the palette menu given the input ViewModel
	public func renderOverlayMenu(vm: LDOverlayMenuViewModel, delegate: OverlayButtonDelegate) {
		
		// Deinit before adding new child nodes to prevent error of child nodes having 2 parents
		deinitOverlayMenu()
		
		// Attach background first
		initBackground()
		
		// Attach close button
		initCloseButton()
		
		// Create and attach Menu Title
		titleNode = SKLabelNode(text: vm.menuName)
		menuNode.addChild(titleNode)
		configureTitleNode()
		
		// Create and attach
		subsectionNode = OverlayMenuSubsection(tileModelArray: vm.tileModelArray)
		menuNode.addChild(subsectionNode)
		
		// Position it
		subsectionNode.position = CGPoint(x: 0, y: Constants.subsectionBaseY)
		maxY = subsectionNode.height / 2 // Divded by 2 because the origin is in the center of the screen
		
		// Add menuNode last
		self.addChild(menuNode)
		
		// Attach delegate
		assignDelegateForButtons(delegate)
		
	}
	
	/**
	Removes the child nodes from parent and reset menuNode
	*/
	private func deinitOverlayMenu() {
		backgroundNode.removeFromParent()
		menuNode.removeFromParent()
		menuNode = SKNode()
	}
	
	private func initBackground() {
		self.addChild(backgroundNode)
		backgroundNode.blendMode = .multiply // To ensure that nodes behind the overlay wont be seen
	}
	
	private func initCloseButton() {
		menuNode.addChild(closeBtnNode)
		closeBtnNode.position = Constants.closeBtnPosition
	}
	
	// MARK: - Helper Private Methods
	
	private func assignDelegateForButtons(_ delegate: OverlayButtonDelegate) {
		subsectionNode.assignDelegateForButtons(delegate)
		closeBtnNode.setDelegate(delegate)
	}
	
	private func configureTitleNode() {
		titleNode.fontName = Constants.titleFontName
		titleNode.fontColor = Constants.titleFontColor
		titleNode.fontSize = Constants.titleFontSize
		titleNode.position = Constants.titlePosition
	}
	
	// MARK: - Scroll Control
	
	private func isValidScroll(_ newPos: CGFloat) -> Bool {
		var maximumYBounds = CGFloat(0)
		
		if (Constants.subsectionBaseY + maxY >= Constants.backgroundHeight) {
			maximumYBounds = maxY
		}
		
		return !(newPos < 0 || newPos > maximumYBounds)
	}
	
	public func scrollMenu(offset: CGFloat) {
		let newYPos = self.menuNode.position.y + offset
		
		if isValidScroll(newYPos) {
			self.menuNode.position.y = newYPos
		}
	}
	
	

}
