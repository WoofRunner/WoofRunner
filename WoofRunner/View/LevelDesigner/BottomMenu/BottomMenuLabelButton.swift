//
//  BottomMenuLabelButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 6/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//
//	The BottomMenuLabelButton subclasses SKLabelNode and conforms 
//	to the LDOverlayButton protocol. It requires a BottomMenuDelegate 
//	to perform tap callbacks.

import SpriteKit

class BottomMenuLabelButton: SKLabelNode, LDOverlayButton {
	
	// MARK: - Private Variables
	
	private var type: BottomMenuButtonType = .rename
	private var delegate: BottomMenuButtonDelegate?
	
	// MARK: - Initialisers
	
	override init() {
		super.init()
	}
	
	/**
	Initialises a BottomMenuLabelButton with the given BottomMenuButtonType with the given text as the initial label text.
	*/
	convenience init(type: BottomMenuButtonType, text: String) {
		self.init()
		self.type = type
		self.text = text
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Methods
	
	/**
	Sets the BottomeMenuButtonDelegate attribute for this button
	*/
	public func setDelegate(_ delegate: BottomMenuButtonDelegate) {
		self.delegate = delegate
	}
	
	// MARK: - LDOverlayButton
	
	internal func onTap() {
		if self.type == .rename {
			self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
				self.delegate?.renameLevel(self.text!)
			})
			return
		}
	}
}
