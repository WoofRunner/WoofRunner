//
//  BottomMenuLabelButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 6/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SpriteKit

class BottomMenuLabelButton: SKLabelNode, LDOverlayButton {
	
	// MARK: - Private Variables
	
	private var type: BottomMenuButtonType = .rename
	private var delegate: BottomMenuButtonDelegate?
	
	// MARK: - Initialisers
	
	override init() {
		super.init()
	}
	
	convenience init(type: BottomMenuButtonType, text: String) {
		self.init()
		self.type = type
		self.text = text
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Public Methods
	
	public func setDelegate(_ delegate: BottomMenuButtonDelegate) {
		self.delegate = delegate
	}
	
	public func onTap() {
		if self.type == .rename {
			self.run(SKAction.sequence([ButtonActions.getButtonPressAction(), ButtonActions.getButtonReleaseAction()]), completion: {
				self.delegate?.renameLevel(self.text!)
			})
			return
		}
	}
}
