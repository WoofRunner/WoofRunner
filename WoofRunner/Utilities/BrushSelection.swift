//
//  BrushSelection.swift
//  WoofRunner
//
//  Created by See Loo Jane on 7/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

struct BrushSelection {
	var selectionType: BrushSelectionType
	var tileModel: TileModel?
	
	static var defaultSelection = BrushSelection(selectionType: .delete, tileModel: nil)
	
	init(selectionType: BrushSelectionType, tileModel: TileModel?) {
		self.selectionType = selectionType
		self.tileModel = tileModel
	}
	
	public func getSelectionName() -> String {
		if let _ = tileModel {
			return tileModel!.name
		}
		
		if selectionType == .delete {
			return "Delete"
		}
		
		print("Error: Cannot determind name for current selection type \(selectionType)")
		return ""
		
	}
	
}
