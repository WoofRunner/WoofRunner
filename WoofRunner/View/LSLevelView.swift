//
//  LSLevelView.swift
//  WoofRunner
//
//  Created by See Loo Jane on 31/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

class LSLevelView: UIView {
	
	var label = UILabel()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		didLoad()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		didLoad()
	}
	
	private func didLoad() {
		label = UILabel(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 500, height: 400))
		label.sizeToFit()
		label.textColor = UIColor.black
	}
	
	func setLevelName(_ name: String) {
		label.text = name
		
	}
	
	
}
