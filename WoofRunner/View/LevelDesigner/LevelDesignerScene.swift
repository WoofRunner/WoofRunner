//
//  LevelDesignerSceneView.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit

class LevelDesignerScene: SCNScene {

    var cameraNode = SCNNode()
    var cameraLocation: SCNVector3 = SCNVector3(0, 0, 0)
    var rxGrid = ReactiveGrid()
    
    override init() {
        super.init()
        self.rxGrid = ReactiveGrid()
        
        let cameraNode = createCameraNode()
        // let lightNode = directionalLightNode()
        
        self.rootNode.addChildNode(cameraNode)
        // Using Default lighting
        // self.rootNode.addChildNode(lightNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func loadLevel(_ levelGrid: LevelGrid) {
        // Dispose previous rxGrid and create new rxGrid
        rxGrid.removeGrid()
        
        // Create new rxGrid that observes the current levelGrid
        rxGrid = ReactiveGrid(levelGrid: levelGrid)
        
        // Add to scene
        rxGrid.grid.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(rxGrid.grid)
    }
    
    func createCameraNode() -> SCNNode {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.name = "Camera"
        
        // Position
        let size = GameSettings.TILE_WIDTH
        cameraNode.position = SCNVector3((Float(LevelGrid.levelCols) * (size * 0.5)),
                                         LevelDesignerViewController.cameraHeight,
                                         LevelDesignerViewController.cameraOffset)
        cameraLocation = cameraNode.position
        
        // Facing Direction
        cameraNode.rotation = SCNVector4(1.0, 0.0, 0.0, LevelDesignerViewController.cameraAngle)
        
        // Orthographic = false
        guard let cameraObject = cameraNode.camera else {
            return cameraNode
        }
        cameraObject.usesOrthographicProjection = false
        return cameraNode
    }
    
    func unloadScene() {
        rxGrid.unloadGrid()
    }
    
    func directionalLightNode() -> SCNNode {
        // Add uniform directional light
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .directional
        lightNode.light!.intensity = 500
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        return lightNode
    }
}
