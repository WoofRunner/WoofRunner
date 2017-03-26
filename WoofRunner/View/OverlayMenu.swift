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
	
	// For OverlayMenu positioning
	static let subsectionSpacingY = CGFloat(120) // Y Spacing between subsections in the menu
	static let subsectionBaseY = CGFloat(400)
	
	// For Subsection titles
	static let subtitleFontName = "AvenirNextCondensed-Bold"
	static let subtitleFontColor = UIColor.white
	static let subtitleFontSize = CGFloat(40)
	static let subtitlePosition = CGPoint(x: 50, y: 50)
	
	// For Buttons
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
	
	private let backgroundNode = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: OverlayConstants.backgroundWidth, height: OverlayConstants.backgroundHeight))
	private let menuNode = SKNode()
	private var maxY = CGFloat(0) // Max y-bound of MenuNode, required for scrolling bounds
	private var arrayOfSubsections = [OverlayMenuSubsection]()
	
	override init() {
		super.init()
	}
	
	// Renders the palette menu at the input position (which is the bottom-left corner
	// of the menu's frame)
	public func renderOverlayMenu(type: PaletteFunctionType) {
		
		// Attach background first
		self.addChild(backgroundNode)
		
		
		// Create and attach Menu Title
		//let menuTitle = type.getName()
		
		
		// Get the set of list of TileTypes to be rendered
		let setOfTileTypes = getSetOfTileTypesFromFunctionType(type)
		
		// Create and attach the subsection nods
		var baseY = OverlayConstants.subsectionBaseY
		var heightOfPrevSubsection = CGFloat(0)
		
		for i in 0..<setOfTileTypes.count {
			
			let setName = setOfTileTypes[i].name
			let array = setOfTileTypes[i].set
			var subsectionNode: OverlayMenuSubsection
			
			// Create
			subsectionNode = OverlayMenuSubsection(sectionName: setName, buttonTypeArray: array)
			
			// Position it
			baseY -= OverlayConstants.subsectionSpacingY + heightOfPrevSubsection
			subsectionNode.position = CGPoint(x: 0, y: baseY)
			
			// Add node
			menuNode.addChild(subsectionNode)
			arrayOfSubsections.append(subsectionNode)
			
			// Update variables for scroll/position calc
			maxY += heightOfPrevSubsection
			heightOfPrevSubsection = subsectionNode.height
		}
		
		// Divide raw y-bounds by 2 as the origin is calculated from the center of the node
		maxY = maxY / 2
		
		// Add menuNode last
		self.addChild(menuNode)
		
	}
	
	private func getSetOfTileTypesFromFunctionType(_ funcType: PaletteFunctionType) -> [TileTypeSet] {
		if funcType == .platform {
			return [
				TileTypeSet(name: "Static", set: [TileType.ground, TileType.ground, TileType.obstacle, TileType.ground]),
				TileTypeSet(name: "Dynamic", set: [TileType.ground, TileType.ground])
			]
		} else {
			return []
		}
	}
	
	private func isValidScroll(_ newPos: CGFloat) -> Bool {
		return !(newPos < 0 || newPos > maxY)
	}
	
	public func scrollMenu(offset: CGFloat) {
		let newYPos = self.menuNode.position.y + offset
		
		if isValidScroll(newYPos) {
			self.menuNode.position.y = newYPos
		}
	}
	
	public func assignDelegateForButtons(_ delegate: OverlayButtonDelegate) {
		for subsection in arrayOfSubsections {
			subsection.assignDelegateForButtons(delegate)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	struct TileTypeSet {
		var name: String
		var set: [TileType]
		
		init(name: String, set: [TileType]) {
			self.name = name
			self.set = set
		}
	}

}
