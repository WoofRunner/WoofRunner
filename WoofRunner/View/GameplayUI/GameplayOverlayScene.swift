//
//  GameplayOverlayScene.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 9/4/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import UIKit
import SpriteKit

class GameplayOverlayScene: SKScene {
    
    private var paletteMenu = PaletteMenu()
    
    override init(size: CGSize) {
        super.init(size: size)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func didLoad() {
        initPaletteMenu()
    }
    
    private func initPaletteMenu() {
        self.paletteMenu.renderPaletteMenu()
        // self.paletteMenu.assignDelegateForButtons(self)
        self.addChild(paletteMenu)
    }
}
