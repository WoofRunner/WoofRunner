//
//  LevelDesignerOverlay.swift
//  WoofRunner
//
//  Created by See Loo Jane on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDesignerOverlayScene: SKScene {
	
	var pauseNode: SKSpriteNode!
	var scoreNode: SKLabelNode!
	//var cameraNode: SKCameraNode!
	
	var extendedMenuBackground: SKSpriteNode!
	var extendedMenuButton1: SKSpriteNode!
	
	var isExtendedMenuShowing = false
	
	var score = 0 {
		didSet {
			self.scoreNode.text = "Score: \(self.score)"
		}
	}
	
	override init(size: CGSize) {
		super.init(size: size)
		
		
		let screenSize: CGRect = UIScreen.main.bounds
		
		self.backgroundColor = UIColor.clear
		
		// Add cat sprite button
		let spriteSize = size.width/12
		self.pauseNode = SKSpriteNode(imageNamed: "testCat")
		self.pauseNode.size = CGSize(width: spriteSize, height: spriteSize)
		self.pauseNode.position = CGPoint(x: spriteSize + 8, y: spriteSize + 8)
		
		// Add score label
		self.scoreNode = SKLabelNode(text: "Score: 0")
		self.scoreNode.fontName = "DINAlternate-Bold"
		self.scoreNode.fontColor = UIColor.black
		self.scoreNode.fontSize = 24
		self.scoreNode.position = CGPoint(x: size.width/2, y: self.pauseNode.position.y - 9)
		
		// Camera setup
		//self.cameraNode = SKCameraNode()
		//self.camera = cameraNode
		
		// Extended Menu
		let buttonSize = size.width/6
		self.extendedMenuBackground = SKSpriteNode(texture: nil, color: UIColor.black, size: CGSize(width: screenSize.width, height: screenSize.height))
		self.extendedMenuBackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		self.extendedMenuButton1 = SKSpriteNode(imageNamed: "testCat")
		self.extendedMenuButton1.size = CGSize(width: buttonSize, height: buttonSize)
		extendedMenuBackground.addChild(extendedMenuButton1)
		extendedMenuBackground.alpha = 0.0
	
		//self.addChild(self.cameraNode)
		self.addChild(self.pauseNode)
		self.addChild(self.scoreNode)
		self.addChild(extendedMenuBackground)
		
		// Initial Position of camera
		//cameraNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		
		
	}
	
	// Handle touch events of the scene
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		let firstTouch = touches.first
		let location = firstTouch?.location(in: self)
		
		if self.pauseNode.contains(location!) {
			
			toggleExtendedMenu()
			self.isExtendedMenuShowing = !self.isExtendedMenuShowing
		} else {
			if isExtendedMenuShowing {
				toggleExtendedMenu()
			}
		}
	}
	
	func toggleExtendedMenu() {
		var fadeAction: SKAction
		
		if isExtendedMenuShowing {
			fadeAction = SKAction.fadeOut(withDuration: 0.5)
		} else {
			fadeAction = SKAction.fadeIn(withDuration: 0.5)
		}
		
		extendedMenuBackground.run(fadeAction)
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
