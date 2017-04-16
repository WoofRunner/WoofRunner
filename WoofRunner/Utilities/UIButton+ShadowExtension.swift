//
//  UIButton+ShadowExtension.swift
//  WoofRunner
//
//  Created by See Loo Jane on 3/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

extension UIButton {
	public func setShadow() {
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 3.0
		self.layer.shadowOpacity = 0.8
		self.layer.shadowOffset = CGSize.zero
		self.layer.masksToBounds = false
	}
}
