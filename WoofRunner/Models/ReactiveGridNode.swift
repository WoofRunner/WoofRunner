//
//  TileNode.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 23/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

class ReactiveGridNode {
    
    let disposeBag = DisposeBag();
    
    var shouldRender: Variable<Bool>
    var platformNode = Variable<SCNNode>(SCNNode())
    var obstacleNode = Variable<SCNNode>(SCNNode())
    
    var position: SCNVector3
    var size: Float
    var platformType: TileType
    var obstacleType: TileType
    var platformModelNode: SCNNode
    var obstacleModelNode: SCNNode
    
    
    init(_ gridVM: GridViewModel) {
        
        self.position = SCNVector3(Float(gridVM.gridPos.value.getCol()) * Tile.TILE_WIDTH,
                                   Float(gridVM.gridPos.value.getRow()) * Tile.TILE_WIDTH, 0)
        self.size = gridVM.size.value
        self.platformType = gridVM.platformType.value
        self.obstacleType = gridVM.obstacleType.value
        self.platformModelNode = SCNNode()
        self.obstacleModelNode = SCNNode()
        
        self.platformNode.value = SCNNode()
        self.obstacleNode.value = SCNNode()
        self.shouldRender = gridVM.shouldRender
        
        updatePlatformNode()
        updateObstacleNode()
        
        // Subscribe to observables
        gridVM.gridPos.asObservable()
            .subscribe(onNext: {
                (pos) in
                self.position = SCNVector3(Float(pos.getCol()) * Tile.TILE_WIDTH, Float(pos.getRow()) * Tile.TILE_WIDTH, 0)
                self.platformNode.value.position = self.position
                self.obstacleNode.value.position = self.position + SCNVector3(0, 0, Tile.TILE_WIDTH)
            }).addDisposableTo(disposeBag)
        
        gridVM.size.asObservable()
            .subscribe(onNext: {
                (size) in
                self.size = size
                self.updatePlatformNode()
                self.updateObstacleNode()
            }).addDisposableTo(disposeBag)
        
        gridVM.platformType.asObservable()
            .subscribe(onNext: {
                (platformType) in
                self.platformType = platformType
                self.updatePlatformNode()
            }).addDisposableTo(disposeBag)
        
        gridVM.obstacleType.asObservable()
            .subscribe(onNext: {
                (obstacleType) in
                self.obstacleType = obstacleType
                self.updateObstacleNode()
            }).addDisposableTo(disposeBag)
    }
    
    private func updatePlatformNode() {
        var modelNode: SCNNode
        
        if platformType == .none {
            // Placeholder block for .none platform
            let size = Tile.TILE_WIDTH
            let platformBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size),
                                             length: CGFloat(size), chamferRadius: 0.05)
            for material in platformBoxGeometry.materials {
                material.emission.contents = UIColor.lightGray
                material.transparency = 0.5
            }
            modelNode = SCNNode(geometry: platformBoxGeometry)
        } else if let model = loadModel(platformType.getModelPath()) {
            modelNode = model
        } else {
            return
        }
        
        // Tag Model Node
        modelNode.name = "modelNode"
        
        // Replace modelNode
        self.platformModelNode.removeFromParentNode()
        self.platformModelNode = modelNode
        self.platformNode.value.addChildNode(platformModelNode)
        self.platformNode.value.position = self.position
    }
    
    private func updateObstacleNode() {
        var modelNode: SCNNode
        
        if obstacleType == .none {
            // Invisible block
            let size = Tile.TILE_WIDTH
            let obstacleBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size),
                                             length: CGFloat(size), chamferRadius: 0.05)
            for material in obstacleBoxGeometry.materials {
                material.emission.contents = UIColor.lightGray
                material.transparency = 0
            }
            modelNode = SCNNode(geometry: obstacleBoxGeometry)
        } else if let model = loadModel(obstacleType.getModelPath()) {
            modelNode = model
        } else {
            return
        }
        // Tag ModelNode
        modelNode.name = "modelNode"
        
        // Replace obstacleModelNode
        self.obstacleModelNode.removeFromParentNode()
        self.obstacleModelNode = modelNode
        self.obstacleNode.value.addChildNode(obstacleModelNode)
        self.obstacleNode.value.position = self.position + SCNVector3(0, 0, Tile.TILE_WIDTH)
    }
    
    // Returns a model node that would be added to gridNode as a childnode
    private func loadModel(_ pathName: String) -> SCNNode? {
        guard let modelScene = SCNScene(named: pathName) else {
            print("WARNING: Cant find path name: " + pathName)
            return nil
        }
        guard let modelNode = modelScene.rootNode.childNodes.first else {
            return nil
        }
        modelNode.position = SCNVector3(-size * 0.5, -size * 0.5, size * 0.5)
        return modelNode
    }
}
