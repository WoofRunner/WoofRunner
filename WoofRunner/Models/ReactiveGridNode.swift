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
    
    static var wireframeMaterial = "art.scnassets/wireframeMaterial.png"
    let disposeBag = DisposeBag();
    
    var shouldRender: Variable<Bool>
    var platformNode = Variable<SCNNode>(SCNNode())
    var obstacleNode = Variable<SCNNode>(SCNNode())
    
    var position: SCNVector3
    var size: Float
    var platformType: PlatformModel?
    var obstacleType: ObstacleModel?
    var platformModelNode: SCNNode
    var obstacleModelNode: SCNNode
    
    
    init(_ gridVM: GridViewModel) {
        
        self.position = SCNVector3(Float(gridVM.gridPos.value.getCol()) * gridVM.size.value,
                                   0.0,
                                   -Float(gridVM.gridPos.value.getRow()) * gridVM.size.value)
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
                self.position = SCNVector3(Float(pos.getCol()) * gridVM.size.value,
                                           0.0,
                                           -Float(pos.getRow()) * gridVM.size.value)
                self.platformNode.value.position = self.position
                self.obstacleNode.value.position = self.position + SCNVector3(0.0, gridVM.size.value, 0.0)
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
        
        if platformType == nil {
            // Placeholder block for nil platform
            let size = self.size
            let platformBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size),
                                             length: CGFloat(size), chamferRadius: 0.05)
            for material in platformBoxGeometry.materials {
                material.diffuse.contents = UIImage(named: ReactiveGridNode.wireframeMaterial)
                material.lightingModel = .constant
                material.isDoubleSided = true
            }
            modelNode = SCNNode(geometry: platformBoxGeometry)
            modelNode.position = SCNVector3(0.5 * size, 0.75 * size, -0.5 * size)
        } else if let model = loadModel(platformType!.scenePath) {
            modelNode = model
        } else {
            return
        }
        
        // Tag Grid Node
        self.platformNode.value.name = GridViewModel.gridNodeName
        
        // Replace modelNode
        freeNode(self.platformModelNode)
        self.platformModelNode = modelNode
        self.platformNode.value.addChildNode(platformModelNode)
        self.platformNode.value.position = self.position
    }
    
    private func updateObstacleNode() {
        var modelNode: SCNNode
        
        if obstacleType == nil {
            // Empty Node
            modelNode = SCNNode()
        } else if let model = loadModel(obstacleType!.scenePath) {
            modelNode = model
        } else {
            return
        }
        
        // Tag GridNode
        self.obstacleNode.value.name = GridViewModel.gridNodeName
        
        // Replace obstacleModelNode
        freeNode(self.obstacleModelNode)
        self.obstacleModelNode = modelNode
        self.obstacleNode.value.addChildNode(obstacleModelNode)
        self.obstacleNode.value.position = self.position + SCNVector3(0.0, size, 0.0)
    }
    
    // Returns a model node that would be added to gridNode as a childnode
    private func loadModel(_ pathName: String?) -> SCNNode? {
        guard let path = pathName else {
            return nil
        }
        guard let modelScene = SCNScene(named: path) else {
            print("WARNING: Cant find path name: " + path)
            return nil
        }
        let modelNode = SCNNode()
        for childNode in modelScene.rootNode.childNodes {
            modelNode.addChildNode(childNode)
        }
        
        return modelNode
    }
    
    // Remove all reference to node to free up memory
    private func freeNode(_ node: SCNNode) {
        if node.childNodes.count > 0 {
            for childNode in node.childNodes {
                freeNode(childNode)
            }
        }
        // Additional measures to de-reference texture from geometry not included
        node.geometry = nil
        node.removeFromParentNode()
    }
}
