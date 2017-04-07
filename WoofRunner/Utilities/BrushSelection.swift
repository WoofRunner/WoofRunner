//
//  BrushSelection.swift
//  WoofRunner
//
//  Created by See Loo Jane on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

struct BrushSelection {
	private(set) var selectionType: BrushSelectionType
	private(set) var tileType: TileType?
	
	init(selectionType: BrushSelectionType, tileType: TileType?) {
		self.selectionType = selectionType
		self.tileType = tileType
	}
}
