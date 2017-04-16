//
//  OverlayButtonDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
To allow child OverlayButton nodes to access callbacks in the parent 
class that created them.
*/
protocol OverlayButtonDelegate {
	
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
	func setCurrentTileSelection(_ tileName: String?)
	
	/**
	Hides the OverlayMenu
	*/
	func closeOverlayMenu()
}
