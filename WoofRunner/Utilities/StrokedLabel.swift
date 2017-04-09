//
//  StrokedLabel.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//  
//  Code inspired by http://stackoverflow.com/a/40575758

import UIKit

// Draws a UILabel with outline
class StrokedLabel: UILabel {
	
	func strokedText(strokeColor: UIColor, fontColor: UIColor, strokeSize: CGFloat, font: UIFont) {
		
		// Retrieve text in UILabel, else default to ""
		let text = self.text ?? ""
		
		let strokeTextAttributes = [
			NSStrokeColorAttributeName : strokeColor,
			NSForegroundColorAttributeName : fontColor,
			NSStrokeWidthAttributeName : -1 * strokeSize,
			NSFontAttributeName : font
			] as [String : Any]
		
		let customizedText = NSMutableAttributedString(string: text,
													   attributes: strokeTextAttributes)
			
			
		self.attributedText = customizedText
	}
}
