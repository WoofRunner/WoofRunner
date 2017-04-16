//
//  LDOverlayDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
To allow child LevelDesignerOverlayScene to access callbacks in the parent
class that created them.
*/
protocol LDOverlayDelegate {
	
	/**
	Performs logic for saving the current level
	*/
	func saveLevel()
	
	/**
	Performs logic for renaming the current level
	*/
	func renameLevel(_ name: String)
	
	/**
	Performs logic when user press back
	*/
	func back()
}
