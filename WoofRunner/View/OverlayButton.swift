//
//  OverlayButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class OverlayButton: RootSKSpriteNode {
	
	private var tileType = TileType.floorLight
	private var overlayButtonDelegate: OverlayButtonDelegate?
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(imageNamed: String, type: TileType, size: CGSize) {
		self.init(texture: SKTexture(imageNamed: imageNamed), color: SKColor.clear, size: size)
		self.tileType = type
	}
	
	public func setDelegate(_ delegate: OverlayButtonDelegate) {
		self.overlayButtonDelegate = delegate
	}
	
	// Logic for tap
	public func onTap() {
		guard let delegate = overlayButtonDelegate else {
			print("Please assign a OverlayButtonDelegate first!")
			return
		}
		
		self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
			
			delegate.setCurrentTileSelection(self.tileType)
			print("Tapped!")
			delegate.closeOverlayMenu()
		})
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
