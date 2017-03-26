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
	static let btnSetBaseX = (backgroundWidth/2) * -1 + btnWidth
	static let btnSetBaseY = subsectionTitleY - 175 - (btnHeight/2 + btnSetMargin)
	static let btnSetSpacingX = CGFloat(50) // X Spacing between buttonSets in a Subsection
	static let btnSetSpacingY = CGFloat(80) // Y Spacing between buttonSets in a Subsection
	
	
}


class OverlayMenu: SKNode {
	
	let backgroundNode = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: OverlayConstants.backgroundWidth, height: OverlayConstants.backgroundHeight))
	
	override init() {
		super.init()
	}
	
	// Renders the palette menu at the input position (which is the bottom-left corner
	// of the menu's frame)
	public func renderOverlayMenu(type: PaletteFunctionType) {
		
		// Attach background first
		self.addChild(backgroundNode)
		
		// Get the set of list of TileTypes to be rendered
		let setOfTileTypes = getSetOfTileTypesFromFunctionType(type)
		
		var baseY = CGFloat(450)
		var heightOfPrevSubsection = CGFloat(0)
		
		// Create and attach the subsection nods
		for i in 0..<setOfTileTypes.count {
			
			let array = setOfTileTypes[i]
			var subsectionNode: OverlayMenuSubsection
			
			// Create
			if i == 0 {
				subsectionNode = OverlayMenuSubsection(sectionName: "Static", buttonTypeArray: array)
			} else {
				subsectionNode = OverlayMenuSubsection(sectionName: "Dynamic", buttonTypeArray: array)
			}
			
			
			// Position it
			baseY -= OverlayConstants.subsectionSpacingY + heightOfPrevSubsection
			subsectionNode.position = CGPoint(x: 0, y: baseY)
			
			// Add node
			self.addChild(subsectionNode)
			
			heightOfPrevSubsection = subsectionNode.height
			
			//print("Position of subsection: \(subsectionNode.position)")
		}
		
	}
	
	private func getSetOfTileTypesFromFunctionType(_ funcType: PaletteFunctionType) -> [[TileType]] {
		return [
			[TileType.ground, TileType.ground, TileType.obstacle, TileType.ground],
			[TileType.ground, TileType.ground]
		]
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
