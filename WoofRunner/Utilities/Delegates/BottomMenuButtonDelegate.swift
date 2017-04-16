//
//  BottomMenuButtonDelegate
//  WoofRunner
//
//  Created by See Loo Jane on 27/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation

/**
To allow child BottomMenuButton nodes to access callbacks in the parent
class that created them.
*/
protocol BottomMenuButtonDelegate {
	
	/**
	Performs logic when user taps "Save" in the BottomMenu
	*/
	func saveLevel()
	
	/**
	Performs logic when user taps "Back" in the BottomMenu
	*/
	func back()
	
	/**
	Performs logic when user taps on the Level name to rename it in the BottomMenu
	*/
	func renameLevel(_ name: String)
}
