//
//  PaletteButtonDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 26/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
To allow child PaletteButton nodes to access callbacks in the parent
class that created them.
*/
protocol PaletteButtonDelegate {
	
	/**
	Performs the tap logic for the input palette function type
	*/
	func handlePaletteTap(_ funcType: PaletteFunctionType)
	
}
