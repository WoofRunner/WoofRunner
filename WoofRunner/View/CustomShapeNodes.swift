//
//  CustomShapeNodes.swift
//  WoofRunner
//
//  Created by See Loo Jane on 21/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import Foundation
import SpriteKit

/**
Contain static methods to create predefined custom SKShapeNodes
*/
struct CustomShapeNodes {
	
	/**
	Creates a rectangular SKShapeNode with rounded corners
	
	- parameters:
		- height: CGFloat height of the rectangle
		- width: CGFloat width of the rectange
		- radius: CGFloat corner radius
		- backgroundColor: Fill color of the rectangle
	
	- returns:
	A rounded rectangular SKShapeNode of the input attributes.
	
	*/
	static func getRoundedRectangleNode(height: CGFloat,
	                                    width: CGFloat,
	                                    radius: CGFloat,
	                                    backgroundColor: SKColor) -> SKShapeNode {
		
		let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: radius)
		node.fillColor = backgroundColor
		
		return node
	}
}
