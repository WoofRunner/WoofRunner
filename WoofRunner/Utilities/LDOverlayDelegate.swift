//
//  LDOverlayDelegate.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

protocol LDOverlayDelegate {	
	func saveLevel()
	func renameLevel(_ newName: String)
	func back()
}
