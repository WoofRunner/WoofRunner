//
//  OverlayButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class OverlayButton: RootSKSpriteNode, LDOverlayButton {
	
	//private var tileType: TileType? = TileType.floorLight
	private var tileName: String? = ""
	private var overlayButtonDelegate: OverlayButtonDelegate?
	
	override init(texture: SKTexture!, color: SKColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
	}
	
	convenience init(imageNamed: String, tileName: String?, size: CGSize) {
		self.init(texture: SKTexture(imageNamed: imageNamed), color: SKColor.clear, size: size)
		self.tileName = tileName
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
			delegate.setCurrentTileSelection(self.tileName)
			delegate.closeOverlayMenu()
		})
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
