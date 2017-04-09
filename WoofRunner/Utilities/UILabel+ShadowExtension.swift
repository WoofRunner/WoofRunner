//
//  UILabel+ShadowExtension.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

extension UILabel {
	
	public func setShadow() {
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 3.0
		self.layer.shadowOpacity = 0.8
		self.layer.shadowOffset = CGSize.zero
		self.layer.masksToBounds = false
	}
}
