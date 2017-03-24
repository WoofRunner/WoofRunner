//
//  LevelDesignerSceneView.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 16/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit

class LevelDesignerScene: SCNScene {

    let chunkLength = 10
    var cameraNode = SCNNode()
    var cameraLocation: SCNVector3 = SCNVector3(0, 0, 0)
    var rxGrid = ReactiveGrid()
    
    override init() {
        super.init()
        self.rxGrid = ReactiveGrid()
        
        let cameraNode = createCameraNode()
        let lightNode = directionalLightNode()
        
        self.rootNode.addChildNode(cameraNode)
        self.rootNode.addChildNode(lightNode)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func loadLevel(_ levelGridVM: [GridViewModel]) {
        // Create rxGrid
        rxGrid = ReactiveGrid()
        
        // Prepare rxGridNodes
        let rxGridNodes: [ReactiveGridNode] = levelGridVM.map({
            (gridVM) in
            let rxGridNode = ReactiveGridNode(gridVM)
            return rxGridNode
        })
        
        // Attach rxGridNodes to rxGrix
        rxGrid.setupGrid(gridNodes: rxGridNodes)
        
        // Add to scene
        rxGrid.grid.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(rxGrid.grid)
    }
    
//    func reloadChunk(camera_y: Float) {
//        let startChunk = Int(camera_y / 2)
//        guard let levelGrid = currentLevelGrid else {
//            return
//        }
//        levelGrid.loadChunk(start: startChunk, chunkLength: chunkLength)
//        updateGrid(levelGrid: levelGrid)
//    }
//    
//    func updateGrid(levelGrid: LevelGridStub) {
//        guard let currentScene = self.scene else {
//            return
//        }
//        
//        for grid in levelGrid.levelGrid {
//            guard let gridVM = gridVMDict[grid.tag] else {
//                continue
//            }
//            let renderChange = gridVM.update(gridModel: grid)
//            if (renderChange) {
//                guard let gridNode = gridNodeDict[gridVM.tag] else {
//                    continue
//                }
//                if (gridVM.shouldRender) {
//                    currentScene.rootNode.addChildNode(gridNode)
//                    gridNode.position = gridVM.position
//                } else {
//                    gridNode.removeFromParentNode()
//                }
//            }
//        }
//    }
    
    func createCameraNode() -> SCNNode {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.name = "Camera"
        
        // Position
        cameraNode.position = SCNVector3Make(1.5, -5.0, 10.0)
        cameraLocation = cameraNode.position
        
        // Facing Direction
        cameraNode.eulerAngles = SCNVector3Make(Float.pi / 4.0, 0.0, 0.0)
        
        // Orthographic = false
        guard let cameraObject = cameraNode.camera else {
            return cameraNode
        }
        cameraObject.usesOrthographicProjection = false
        return cameraNode
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

	
//    func handlePan(_ sender: UIPanGestureRecognizer) {
//        guard let camera = cameraNode else {
//            return
//        }
//        let view = self
//        
//        let translation = sender.translation(in: view)
//        
//        let location = sender.location(in: view)
//        let secLocation = CGPoint(x: location.x + translation.x,
//                                  y: location.y + translation.y)
//        
//        let P1 = view.unprojectPoint(SCNVector3(x: Float(location.x), y: Float(location.y), z: 0.0))
//        let P2 = view.unprojectPoint(SCNVector3(x: Float(location.x), y: Float(location.y), z: 1.0))
//        
//        let Q1 = view.unprojectPoint(SCNVector3(x: Float(secLocation.x), y: Float(secLocation.y), z: 0.0))
//        let Q2 = view.unprojectPoint(SCNVector3(x: Float(secLocation.x), y: Float(secLocation.y), z: 1.0))
//        
//        let t1 = -P1.z / (P2.z - P1.z)
//        
//        let y1 = P1.y + t1 * (P2.y - P1.y)
//        
//        let P0 = SCNVector3Make(0, y1,0)
//        
//        let y2 = Q1.y + t1 * (Q2.y - Q1.y)
//        
//        let Q0 = SCNVector3Make(0, y2, 0)
//        
//        let diffR = P0.y - Q0.y
//        
//        switch sender.state {
//        case .began:
//            cameraLocation = camera.position
//            break;
//        case .changed:
//            let newPos = SCNVector3(cameraLocation.x,
//                                         cameraLocation.y + diffR,
//                                         cameraLocation.z)
//            if (newPos.y >= -10) {
//                camera.position = newPos
//            }
//            
//            reloadChunk(camera_y: camera.position.y)
//            break;
//        default:
//            break;
//        }
//    }
//	
//	
//    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//        // retrieve the SCNView
//        let view = self
//        
//        // check what nodes are tapped
//        let p = gestureRecognize.location(in: view)
//        let hitResults = view.hitTest(p, options: [:])
//        // check that we clicked on at least one object
//        if hitResults.count > 0 {
//            for result in hitResults {
//                let gridNode = result.node
//                if toggleGridBlock(gridNode.position) {
//                    updateGrid(levelGrid: currentLevelGrid!)
//                    return
//                }
//            }
//        }
//    }
//
//    
//    private func toggleGridBlock(_ pos: SCNVector3) -> Bool {
//        guard let levelGrid = currentLevelGrid else {
//            return false
//        }
//        for (_, gridVM) in gridVMDict {
//            if gridVM.position.x == pos.x && gridVM.position.y == pos.y {
//                for gridModel in levelGrid.levelGrid {
//                    if gridModel.tag == gridVM.tag {
//                        gridModel.hasItem = true
//                        gridModel.toggleType()
//                        return true
//                    }
//                }
//            }
//        }
//        return false
//    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//class GridStub {
//    
//    var position: (row: Int, col: Int)
//    var hasItem: Bool
//    var shouldRender: Bool
//    var type: Int
//    var tag: Int
//    
//    static var maxType = 2
//    static var size: Float = 2.0
//    
//    init(row: Int, col: Int, tag: Int) {
//        position = (row: row, col: col)
//        hasItem = false
//        shouldRender = false
//        type = 0
//        self.tag = tag
//    }
//    
//    func toggleType() {
//        type += 1
//        if type >= GridStub.maxType {
//            type = 0
//        }
//    }
//}
//
//class GridViewModelStub {
//    
//    var boxGeometry: SCNBox
//    var position: SCNVector3
//    var shouldRender: Bool
//    var tag: Int
//    
//    static var colors = [UIColor.blue, UIColor.red, UIColor.lightGray]
//    
//    init(gridModel: GridStub) {
//        let size = CGFloat(GridStub.size)
//        shouldRender = gridModel.shouldRender
//        tag = gridModel.tag
//        
//        boxGeometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0.05)
//        for material in boxGeometry.materials {
//            if !gridModel.hasItem {
//                material.emission.contents = GridViewModelStub.colors[2]
//                material.transparency = 1
//            } else {
//                material.emission.contents = GridViewModelStub.colors[gridModel.type]
//                material.transparency = 1
//            }
//        }
//        let xPos = Float(gridModel.position.col) * Float(size)
//        let yPos = Float(gridModel.position.row) * Float(size)
//        position = SCNVector3(x: xPos, y: yPos, z: 0)
//    }
//    
//    func update(gridModel: GridStub) -> Bool {
//        
//        // Update Item
//        for material in boxGeometry.materials {
//            if !gridModel.hasItem {
//                material.emission.contents = GridViewModelStub.colors[2]
//                material.transparency = 1
//            } else {
//                material.emission.contents = GridViewModelStub.colors[gridModel.type]
//                material.transparency = 1
//            }
//        }
//        
//        // Update Render
//        if shouldRender != gridModel.shouldRender {
//            shouldRender = gridModel.shouldRender
//            return true
//        } else {
//            return false
//        }
//    }
//}
