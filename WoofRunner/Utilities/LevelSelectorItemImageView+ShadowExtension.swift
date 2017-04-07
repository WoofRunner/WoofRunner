//
//  LevelSelectorItemImageView+ShadowExtension.swift
//  WoofRunner
//
//  Created by See Loo Jane on 8/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit

extension LevelSelectorItemImageView {
	public func setShadow() {
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 1
		self.layer.shadowOffset = CGSize.zero
		self.layer.shadowRadius = 10
		self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
	}
}
