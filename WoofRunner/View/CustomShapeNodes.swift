//
//  CustomShapeNodes.swift
//  WoofRunner
//
//  Created by See Loo Jane on 21/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SpriteKit

struct CustomShapeNodes {
	
	static func getRoundedRectangleNode(height: CGFloat,
	                                    width: CGFloat,
	                                    radius: CGFloat,
	                                    backgroundColor: SKColor) -> SKShapeNode {
		
		let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: radius)
		node.fillColor = backgroundColor
		
		return node
	}
}
