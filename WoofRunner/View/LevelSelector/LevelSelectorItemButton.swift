//
//  LevelSelectorItemButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 6/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

/**
Generic class for buttons in LevelCardView and its subclasses
*/
public class LevelSelectorItemButton: UIButton {
	
	private var uuid: String = "" // The level UUID tied to the level selector item that the button is in
	
	// MARK: - Public Methods
	
	/**
	Binds the input uuid string to the button.
	
	- parameters:
		- uuid: The uuid string of the level that the button's parent LevelCardView is bounded to
	*/
	public func bindUUID(_ uuid: String) {
		self.uuid = uuid
	}
	
	/**
	Returns the uuid binded to the button
	*/
	public func getBindedUUID() -> String {
		return self.uuid
	}
	
	
}
