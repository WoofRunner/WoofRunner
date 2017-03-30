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

class LevelDesignerOverlayScene: SKScene,
								PaletteButtonDelegate,
								OverlayButtonDelegate,
								BottomMenuButtonDelegate {
	
	var overlayDelegate: LDOverlayDelegate?
	var paletteMenu = PaletteMenu()
	var overlayMenu = OverlayMenu()
	var currentSelectionUI = CurrentSelectionNode()
	var bottomMenu = LevelDesignerBottomMenu()
	
	var currentTileSelection = Variable<TileType>(.floorLight) // Default selection. Wrap this in RXSwift
	
	
	var oldY = CGFloat(0) // Recorded y coords of the most recent user touch
	
	override init(size: CGSize) {
		super.init(size: size)
		self.backgroundColor = UIColor.clear
		
		initPaletteMenu()
		initOverlayMenu()
		initCurrentSelection()
		initBottomMenu()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public func setDelegate(_ delegate: LDOverlayDelegate) {
		self.overlayDelegate = delegate
	}
	
	// - MARK: Init Nods
	
	private func initPaletteMenu() {
		self.paletteMenu.renderPaletteMenu()
		self.paletteMenu.assignDelegateForButtons(self)
		self.addChild(paletteMenu)
	}
	
	private func initOverlayMenu() {
		self.overlayMenu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		self.overlayMenu.alpha = 0.0
		self.addChild(overlayMenu)
	}
	
	private func initCurrentSelection() {
		let currentSelectionPosX = CGFloat(690)
		let currentSelectionPosY = CGFloat(880)
		self.addChild(currentSelectionUI)
		self.currentSelectionUI.position = CGPoint(x: currentSelectionPosX, y: currentSelectionPosY)
	}
	
	private func initBottomMenu() {
		self.bottomMenu.position =  CGPoint(x: self.frame.midX, y: self.frame.minY + 40)
		self.bottomMenu.setButtonDelegates(self)
		self.addChild(bottomMenu)
	}
	
	// - MARK: Handle Touches
	
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
		
		if let bottomMenuBtnNode = node as? BottomMenuButton {
			bottomMenuBtnNode.onTap()
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
	
	// - MARK: PaletteButtonDelegate
	internal func handlePaletteTap(_ funcType: PaletteFunctionType) {
		if funcType == .delete {
			setCurrentTileSelection(.none)
		} else {
			openOverlayMenu(funcType)
		}
	}
	
	func openOverlayMenu(_ funcType: PaletteFunctionType) {
		self.overlayMenu.renderOverlayMenu(type: funcType, delegate: self)
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.98, duration: 0.2))
	}
	
	
	// - MARK: OverlayButtonDelegate
	internal func setCurrentTileSelection(_ type: TileType) {
		self.currentTileSelection.value = type
		self.currentSelectionUI.updateSelectionText(type.toString())
	}
	
	internal func closeOverlayMenu() {
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.0, duration: 0.2))
	}
	
	// - MARK: BottomMenuButtonDelegate
	internal func back() {
		self.overlayDelegate?.back()
	}
	
	internal func saveLevel() {
		print("save level")
		self.overlayDelegate?.saveLevel()
	}
	

}
