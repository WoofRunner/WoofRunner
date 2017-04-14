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

/**
Displays the UI for the LevelDesignerScene and parents the PaletteMenu,
OverlayMenu, CurrentSelectionUI and BottomMenu nodes.
*/
class LevelDesignerOverlayScene: SKScene,
								PaletteButtonDelegate,
								OverlayButtonDelegate,
								BottomMenuButtonDelegate {
	
	// MARK: - Private Variables

	private let factory = TileModelFactory.sharedInstance // Have to create factory before accessing tileModels
	private let allTileModels = TileModelFactory.sharedInstance.tileModels // Retrieve list of unique TileModels
	private var overlayDelegate: LDOverlayDelegate?
	private var paletteMenu = PaletteMenu()
	private var overlayMenu = OverlayMenu()
	private var currentSelectionUI = CurrentSelectionNode()
	private var bottomMenu = LevelDesignerBottomMenu()
	
	// To keep track internally which selection type is last activated
	private var currentBrushSelectionType: BrushSelectionType = .delete
	private var oldY = CGFloat(0) // Recorded y coords of the most recent user touch
	
	// MARK: - Public Variables
	
	// To be accessed by LevelDesignerScene
	var currentBrushSelection = Variable<BrushSelection>(BrushSelection.defaultSelection)
	
	// MARK: - Initialisers
	
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
	
	
	// - MARK: Private View Set Up Methods
	
	private func didLoad() {
		self.backgroundColor = UIColor.clear
		initPaletteMenu()
		initCurrentSelection()
		initBottomMenu()
		initOverlayMenu()
	}
	
	private func initPaletteMenu() {
		self.paletteMenu.assignDelegateForButtons(self)
		self.addChild(paletteMenu)
	}
	
	private func initOverlayMenu() {
		self.overlayMenu.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		self.overlayMenu.alpha = 0.0
		self.addChild(overlayMenu)
	}
	
	private func initCurrentSelection() {
		self.currentSelectionUI = CurrentSelectionNode(defaultSelectionText: currentBrushSelection.value.getSelectionName())
		let currentSelectionPosX = CGFloat(660)
		let currentSelectionPosY = CGFloat(880)
		self.addChild(currentSelectionUI)
		self.currentSelectionUI.position = CGPoint(x: currentSelectionPosX, y: currentSelectionPosY)
	}
	
	private func initBottomMenu() {
		self.bottomMenu.position =  CGPoint(x: self.frame.midX, y: self.frame.minY + 40)
		self.bottomMenu.setButtonDelegates(self)
		self.addChild(bottomMenu)
	}
	
	// MARK: - Private helper methods
	
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
	
	/**
	Render and show the appropriate OverlayMenu given the input PaletteFunctionType
	*/
	private func openOverlayMenu(_ funcType: PaletteFunctionType) {
		let vm = LDOverlayMenuViewModel(funcType: funcType, allTileModels: allTileModels)
		self.overlayMenu.renderOverlayMenu(vm: vm, delegate: self)
		animateOverlayMenuOpen()
	}
	
	/**
	Updates the current BrushSelectionType with the input selectionType
	*/
	private func updateBrushSelectionType(_ selectionType: BrushSelectionType) {
		currentBrushSelectionType = selectionType
	}
	
	/**
	Updates the currentBrushSelection, using the last recorded brushSelectionType
	as the value for the selectionType attribute, and the input TileModel
	for the tileModel attribute. Also updates the currentSelectionUI accordingly
	
	- parameters:
		- tileModel: TileModel object to be set for the currentBrushSelection. nil if 
						it is not applicable (ie. for delete function)
	*/
	private func updateBrushSelection(_ tileModel: TileModel?) {
		currentBrushSelection.value.tileModel = tileModel
		currentBrushSelection.value.selectionType = currentBrushSelectionType
		updateCurrentSelectionUI()
	}
	
	/**
	Updates the selection UI text according to the currentBrushSelection
	*/
	private func updateCurrentSelectionUI() {
		let selectionName = currentBrushSelection.value.getSelectionName()
		currentSelectionUI.updateSelectionText(selectionName)
	}
	
	// MARK: - Public Methods
	
	public func setDelegate(_ delegate: LDOverlayDelegate) {
		self.overlayDelegate = delegate
	}
	
	/**
	Returns if there is currently an OverlayMenu displayed
	*/
	public func isOverlayMenuVisible() -> Bool {
		return overlayMenu.alpha > 0
	}
	
	
	// - MARK: Handle Naming
	
	/**
	Updates the level name that is displayed on the BottomMenu to the input string.
	*/
	public func updateDisplayedLevelName(_ name: String) {
		bottomMenu.setLevelName(name)
	}
	
	// - MARK: Handle Touches
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		let node = self.atPoint(location!)
		
		// Save y-pos of touch for calculating offset of scrolling if needed
		self.oldY = (location?.y)!
		
		// Handle button tap on touch begin
		if let btnNode = node as? LDOverlayButton {
			btnNode.onTap()
			return
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		// Handle menu scrolling if OverlayMenu is visible
		if isOverlayMenuVisible() {
			let offset = (location?.y)! - oldY
			self.overlayMenu.scrollMenu(offset: offset)
			self.oldY = (location?.y)!
		}
	}
	
	
	// - MARK: PaletteButtonDelegate
	
	/**
	Perform the tap logic given an input PaletteFunctionType
	*/
	internal func handlePaletteTap(_ funcType: PaletteFunctionType) {
		switch funcType {
			case .delete:
				updateBrushSelectionType(.delete)
				updateBrushSelection(nil) // Delete selection has no attached TileModel
				updateCurrentSelectionUI()
			case .obstacle:
				updateBrushSelectionType(.obstacle)
				openOverlayMenu(funcType)
			case .platform:
				updateBrushSelectionType(.platform)
				openOverlayMenu(funcType)
		}
	}
	
	
	
	// - MARK: OverlayButtonDelegate
	
	/**
	
	Fetch the TileModel using the input tileName and use it to update
	the current brush selection, followed by updating the selectionUI text
	
	- parameters:
		- tileName: Name string of the TileModel that is to be set as the current selection. 
					Input nil if not applicable.
	
	- important:
	TileName is used so that child node classes such as OverlayButtonSet
	and OverlayButton will not be coupled to TileModel
	
	*/
	internal func setCurrentTileSelection(_ tileName: String?) {
		guard let _ = tileName else {
			return
		}
		
		let tileModel = getTileModelFromName(tileName!)
		
		guard let _ = tileModel else {
			return
		}
		
		updateBrushSelection(tileModel)
	}
	
	internal func closeOverlayMenu() {
		animateOverlayMenuClose()
	}
	
	// - MARK: BottomMenuButtonDelegate
	
	internal func back() {
		
		// Needs to be async or this function will not be able to end
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
