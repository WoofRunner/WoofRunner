//
//  OverlayMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//
//	OverlayMenu contains a MenuTitleLabel and a OverlayMenuSubsection
//	which contains the OverayButtons. Its position should be set by the
//	parent creator class, and should be rendered using a LDOverlayMenuViewModel.

import SpriteKit

class OverlayMenu: SKNode {
	
	typealias Constants = LDOverlaySceneConstants.OverlayConstants
	
	// MARK: - Private Variables
	
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
	
	/**
	Resets the menuNode previously attached to the OverlayMenu and attach a new menuNode
	that is created according to the input LDOverlayMenuViewModel. Also assigns the input
	OverlayButtonDelegate to the OverlayButtons accordingly.
	*/
	public func renderOverlayMenu(vm: LDOverlayMenuViewModel, delegate: OverlayButtonDelegate) {
		
		// Deinit before adding new child nodes to prevent error of child nodes having 2 parents
		deinitOverlayMenu()
		
		initBackground()
		initCloseButton()
		initMenuTitleLabel(vm.menuName)
		initOverlaySubsections(tileModelArray: vm.tileModelArray)
		self.addChild(menuNode)
		
		// Attach delegate
		assignDelegateForButtons(delegate)
		
	}
	
	// MARK: - Private Helper methods to initialse view
	
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
	
	private func initMenuTitleLabel(_ text: String) {
		titleNode = SKLabelNode(text: text)
		menuNode.addChild(titleNode)
		configureTitleNode()
	}
	
	private func initOverlaySubsections(tileModelArray: [TileModel]) {
		// Create and attach subsection
		subsectionNode = OverlayMenuSubsection(tileModelArray: tileModelArray)
		menuNode.addChild(subsectionNode)
		
		// Position it
		subsectionNode.position = CGPoint(x: Constants.subsectionBaseX,
		                                  y: Constants.subsectionBaseY)
		maxY = subsectionNode.height / 2 // Divded by 2 because the origin is in the center of the screen
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
	
	// Returns whether or not the input position is a valid position to scroll to
	private func isValidScroll(_ newPos: CGFloat) -> Bool {
		var maximumYBounds = CGFloat(0)
		
		if (Constants.subsectionBaseY + maxY >= Constants.backgroundHeight) {
			maximumYBounds = maxY
		}
		
		return !(newPos < 0 || newPos > maximumYBounds)
	}
	
	/**
	Checks if the input offset results in a valid scroll y-coordinate and moves the OverlayMenu accordingly, else do nothing.
	- parameters: 
		- offset: CGFloat value indicating the y offset for the scroll to be performed
	*/
	public func scrollMenu(offset: CGFloat) {
		let newYPos = self.menuNode.position.y + offset
		
		if isValidScroll(newYPos) {
			self.menuNode.position.y = newYPos
		}
	}
	
	

}
