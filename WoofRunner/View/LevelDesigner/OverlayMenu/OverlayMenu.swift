//
//  OverlayMenu.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

struct OverlayConstants {
	
	// For Background
	static let backgroundWidth = UIScreen.main.bounds.width
	static let backgroundHeight = UIScreen.main.bounds.height
	static let backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.99)
	
	// For OverlayMenu positioning
	static let subsectionSpacingY = CGFloat(120) // Y Spacing between subsections in the menu
	static let subsectionBaseY = CGFloat(400)
	
	// For Overlay Menu Title
	static let titleFontName = "AvenirNextCondensed-Bold"
	static let titleFontColor = UIColor.white
	static let titleFontSize = CGFloat(55)
	static let titlePosition = CGPoint(x: 0, y: backgroundHeight/2 - 60)
	
	// For Overlay Menu Close Button
	static let closeBtnSize = CGSize(width: 45, height: 45)
	static let closeBtnPosition = CGPoint(x: backgroundWidth/2 - 45, y: backgroundHeight/2 - 45)
	static let closeBtnImageSprite = "close-overlay-button"
	
	// For Subsection titles
	static let subtitleFontName = "AvenirNextCondensed-Bold"
	static let subtitleFontColor = UIColor.white
	static let subtitleFontSize = CGFloat(40)
	static let subtitlePosition = CGPoint(x: 50, y: 50)
	
	// For Tile Buttons
	static let btnWidth = CGFloat(150)
	static let btnHeight = CGFloat(150)
	
	// Button Set Positioning
	static let btnMargin = CGFloat(30)
	static let btnX = CGFloat(0)
	static let btnY = CGFloat(btnHeight/2 + btnMargin)
	static let btnLabelPosition = CGPoint(x: 0, y: 0)
	
	// Button Label
	static let btnLabelFontName = "AvenirNextCondensed-Medium"
	static let btnLabelFontColor = UIColor.white
	static let btnLabelFontSize = CGFloat(20)
	
	// For Subsection positioning
	static let btnSetMargin = CGFloat(30)
	static let subsectionTitleY = CGFloat(0)
	static let subsectionTitleX = btnSetBaseX
	static let subsectionLabelAndBtnSetSpacingY = CGFloat(175)
	static let btnSetBaseX = (backgroundWidth / 2) * -1 + btnWidth
	static let btnSetBaseY = subsectionTitleY - subsectionLabelAndBtnSetSpacingY - (btnHeight / 2 + btnSetMargin)
	static let btnSetSpacingX = CGFloat(50) // X Spacing between buttonSets in a Subsection
	static let btnSetSpacingY = CGFloat(80) // Y Spacing between buttonSets in a Subsection
}


class OverlayMenu: SKNode {
	
	private let backgroundNode = SKSpriteNode(texture: nil, color: OverlayConstants.backgroundColor, size: CGSize(width: OverlayConstants.backgroundWidth, height: OverlayConstants.backgroundHeight))
	private var titleNode = SKLabelNode()
	private var closeBtnNode = OverlayButton(imageNamed: OverlayConstants.closeBtnImageSprite, tileName: nil, size: OverlayConstants.closeBtnSize)
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
	
	// MARK: - Render Method
	
	// Renders the palette menu given the input ViewModel
	public func renderOverlayMenu(vm: LDOverlayMenuViewModel, delegate: OverlayButtonDelegate) {
		
		// Reset
		backgroundNode.removeFromParent()
		menuNode.removeFromParent()
		menuNode = SKNode()
		
		// Attach background first
		self.addChild(backgroundNode)
		backgroundNode.blendMode = .multiply // To ensure that nodes behind the overlay wont be seen
		
		// Attach close button
		menuNode.addChild(closeBtnNode)
		closeBtnNode.position = OverlayConstants.closeBtnPosition
		
		// Create and attach Menu Title
		titleNode = SKLabelNode(text: vm.menuName)
		menuNode.addChild(titleNode)
		configureTitleNode()
		
		// Create and attach
		subsectionNode = OverlayMenuSubsection(tileModelArray: vm.tileModelArray)
		menuNode.addChild(subsectionNode)
		
		// Position it
		subsectionNode.position = CGPoint(x: 0, y: OverlayConstants.subsectionBaseY)
		maxY = subsectionNode.height / 2 // Divded by 2 because the origin is in the center of the screen
		
		// Add menuNode last
		self.addChild(menuNode)
		
		// Attach delegate
		assignDelegateForButtons(delegate)
		
	}
	
	// MARK: - Scroll Control
	
	private func isValidScroll(_ newPos: CGFloat) -> Bool {
		var maximumYBounds = CGFloat(0)
		
		if (OverlayConstants.subsectionBaseY + maxY >= OverlayConstants.backgroundHeight) {
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
	
	// MARK: - Helper Private Methods
	
	private func assignDelegateForButtons(_ delegate: OverlayButtonDelegate) {
		subsectionNode.assignDelegateForButtons(delegate)
		closeBtnNode.setDelegate(delegate)
	}
	
	private func configureTitleNode() {
		titleNode.fontName = OverlayConstants.titleFontName
		titleNode.fontColor = OverlayConstants.titleFontColor
		titleNode.fontSize = OverlayConstants.titleFontSize
		titleNode.position = OverlayConstants.titlePosition
	}

}
