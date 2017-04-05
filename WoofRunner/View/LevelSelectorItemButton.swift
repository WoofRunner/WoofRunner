//
//  LevelSelectorItemButton.swift
//  WoofRunner
//
//  Created by See Loo Jane on 6/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class LevelSelectorItemButton: UIButton {
	
	private var uuid: String = "" // The level UUID tied to the level selector item that the button is in

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	public func bindUUID(_ uuid: String) {
		self.uuid = uuid
	}
	
	public func getBindedUUID() -> String {
		return self.uuid
	}
	
	
}
