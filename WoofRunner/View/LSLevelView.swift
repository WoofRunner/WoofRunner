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
		label.backgroundColor = UIColor.blue
		label.textAlignment = .center
		label.textColor = UIColor.white
		label.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(label)
		
		let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
		let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
		var constraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:[superview]-(<=1)-[label]",
			options: NSLayoutFormatOptions.alignAllCenterX,
			metrics: nil,
			views: ["superview":self, "label":label]
		)
		
		self.addConstraints(constraints)
		
		// Center vertically
		constraints = NSLayoutConstraint.constraints(
			withVisualFormat: "H:[superview]-(<=1)-[label]",
			options: NSLayoutFormatOptions.alignAllCenterY,
			metrics: nil,
			views: ["superview":self, "label":label]
		)
		
		self.addConstraints(constraints)
		self.addConstraints([widthConstraint, heightConstraint])

	}
	
	func setLevelName(_ name: String) {
		label.text = name
		
	}
	
	
}
