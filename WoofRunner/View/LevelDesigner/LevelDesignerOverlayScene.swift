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
	
	// Retrieve list of unique TileModels
	let factory = TileModelFactory.sharedInstance
	let allTileModels = TileModelFactory.tileModels
	
	var overlayDelegate: LDOverlayDelegate?
	var paletteMenu = PaletteMenu()
	var overlayMenu = OverlayMenu()
	var currentSelectionUI = CurrentSelectionNode()
	var bottomMenu = LevelDesignerBottomMenu()
	
	var currentTileSelection = Variable<TileType>(.floorLight) // Default selection. Wrap this in RXSwift
	var currentBrushSelection = Variable<BrushSelection>(BrushSelection.defaultSelection)
	
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
	
	private func getTileModelFromName(_ name: String) -> TileModel? {
		for tileModel in allTileModels {
			if tileModel.name == name {
				return tileModel
			}
		}
		
		return nil
	}
	
	private func animateOverlayMenuClose() {
		self.overlayMenu.run(SKAction.fadeAlpha(to: 0.0, duration: 0.2))
	}

	private func animateOverlayMenuOpen() {
		self.overlayMenu.run(SKAction.fadeAlpha(to: 1.0, duration: 0.2))
	}

	
	// - MARK: PaletteButtonDelegate
	internal func handlePaletteTap(_ funcType: PaletteFunctionType) {
		switch funcType {
			case .delete:
				updateBrushSelection(.delete)
			case .obstacle:
				updateBrushSelection(.obstacle)
				openOverlayMenu(funcType)
			case .platform:
				updateBrushSelection(.platform)
				openOverlayMenu(funcType)
			default:
				break
		}
	}
	
	private func openOverlayMenu(_ funcType: PaletteFunctionType) {
		let vm = LDOverlayMenuViewModel(funcType: funcType, allTileModels: allTileModels)
		self.overlayMenu.renderOverlayMenu(vm: vm, delegate: self)
		animateOverlayMenuOpen()
	}
	
	// Updates the current brush selection BrushSelectionType attribute
	private func updateBrushSelection(_ selectionType: BrushSelectionType) {
		self.currentBrushSelection.value.selectionType = selectionType
	}
	
	// Updates the current brush selection TileModel attribute
	private func updateBrushSelection(_ tileModel: TileModel?) {
		self.currentBrushSelection.value.tileModel = tileModel
	}
	
	// - MARK: OverlayButtonDelegate
	
	// Fetch the TileModel using the input tileName,
	// and use it to update the current brush selection
	internal func setCurrentTileSelection(_ tileName: String?) {
		guard let _ = tileName else {
			return
		}
		
		let tileModel = getTileModelFromName(tileName!)
		
		guard let _ = tileModel else {
			return
		}
		
		updateBrushSelection(tileModel)
		self.currentSelectionUI.updateSelectionText(tileName!)
	}
	
	// Closes the OverlayMenu with an animation
	internal func closeOverlayMenu() {
		animateOverlayMenuClose()
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
