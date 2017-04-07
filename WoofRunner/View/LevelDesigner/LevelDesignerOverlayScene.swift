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
		didLoad()
	}
	
	convenience init(size: CGSize, levelName: String) {
		self.init(size: size)
		bottomMenu.setLevelName(levelName)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		didLoad()
	}
	
	public func setDelegate(_ delegate: LDOverlayDelegate) {
		self.overlayDelegate = delegate
	}
	
	// - MARK: Init Nods
	
	private func didLoad() {
		self.backgroundColor = UIColor.clear
		initPaletteMenu()
		initCurrentSelection()
		initBottomMenu()
		initOverlayMenu()
	}
	
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
		self.currentSelectionUI = CurrentSelectionNode(defaultSelection: currentTileSelection.value)
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
	
	// - MARK: Handle Naming
	
	public func updateDisplayedLevelName(_ name: String) {
		bottomMenu.setLevelName(name)
	}
	
	// - MARK: Handle Touches
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		// Save y-pos of touch for calculating offset of scrolling if needed
		self.oldY = (location?.y)!
		
		let node = self.atPoint(location!)
		
		if let btnNode = node as? LDOverlayButton {
			btnNode.onTap()
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
	
	// MARK: - Private helper methods
	
	private func isOverlayMenuVisible() -> Bool {
		return overlayMenu.alpha > 0
	}
	
	// Hides the overlay menu if it is visible currently
	private func hideOverlayMenu() {
		if isOverlayMenuVisible() {
			animateOverlayMenuClose()
		}
	}
	
	private func animateOverlayMenuClose() {
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.0, duration: 0.2))
	}

	private func animateOverlayMenuOpen() {
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.98, duration: 0.2))
	}

	
	// - MARK: PaletteButtonDelegate
	internal func handlePaletteTap(_ funcType: PaletteFunctionType) {
		if funcType == .delete {
			setCurrentTileSelection(TileType.none)
		} else {
			openOverlayMenu(funcType)
		}
	}
	
	private func openOverlayMenu(_ funcType: PaletteFunctionType) {
		self.overlayMenu.renderOverlayMenu(type: funcType, delegate: self)
		animateOverlayMenuOpen()
	}
	
	
	// - MARK: OverlayButtonDelegate
	internal func setCurrentTileSelection(_ type: TileType?) {
		guard let _ = type else {
			return
		}
		
		self.currentTileSelection.value = type!
		self.currentSelectionUI.updateSelectionText(type!.toString())
	}
	
	internal func closeOverlayMenu() {
		hideOverlayMenu()
	}
	
	// - MARK: BottomMenuButtonDelegate
	
	internal func back() {
		DispatchQueue.main.async() {
			self.overlayDelegate?.back()
		}
	}
	
	internal func saveLevel() {
		self.overlayDelegate?.saveLevel()
	}
	
	internal func renameLevel(_ name: String) {
		self.overlayDelegate?.renameLevel(name)
	}
	

}
