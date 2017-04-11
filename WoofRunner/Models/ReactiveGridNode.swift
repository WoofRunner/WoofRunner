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

/// This class holds the view properties of a Grid View Model in the Level Designer.
/// The reactive grid node contains both a platform and an obstacle SCNNode which will
/// hold the model of the observed TileModel of their respective Grid View Model.
class ReactiveGridNode {
    
    static let wireframeMaterial = "art.scnassets/wireframeMaterial.png"
    let disposeBag = DisposeBag();
    
    // Observables
    var shouldRender: Variable<Bool>
    var platformNode = Variable<SCNNode>(SCNNode())
    var obstacleNode = Variable<SCNNode>(SCNNode())
    
    // Member variables
    var position: SCNVector3
    var size: Float
    var platformType: PlatformModel?
    var obstacleType: ObstacleModel?
    var platformModelNode: SCNNode
    var obstacleModelNode: SCNNode
    
    var cachedPlatform: String?
    var cachedObstacle: String?
    
    /// Creates a Reactive Grid object that observes the specified Grid View Model
    /// - Parameters: 
    ///     - gridVM: Grid View Model object to be observed by the reactive grid node
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
        
        // Initialise model nodes
        updatePlatformNode()
        updateObstacleNode()
        
        // Subscribe to observables of Grid View Model
        gridVM.gridPos.asObservable()
            .subscribe(onNext: {
                (pos) in
                self.position = SCNVector3(Float(pos.getCol()) * gridVM.size.value,
                                           0.0,
                                           -Float(pos.getRow()) * gridVM.size.value)
                self.platformNode.value.position = self.position
                self.obstacleNode.value.position = self.position + SCNVector3(0.0, gridVM.size.value, 0.0)
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

        gridVM.shouldRender.asObservable()
            .subscribe(onNext: {
                (render) in
                if render {
                    self.updateObstacleNode()
                    self.updatePlatformNode()
                }
            }).addDisposableTo(disposeBag)
    }
    
    /// Unloads all resources in the grid
    public func unloadGridNode() {
        freeNode(platformNode.value)
        freeNode(obstacleNode.value)
    }
    
    /// Called when observed platform TileModel changes.
    /// Updates the platform node's model
    private func updatePlatformNode() {
        var modelNode: SCNNode
        
        guard shouldRender.value else {
            return
        }
        
        guard let model = renderPlatformNode() else {
            return
        }
        
        modelNode = model
        
        // Tag Grid Node
        self.platformNode.value.name = GridViewModel.gridNodeName
        
        // Replace modelNode
        freeNode(self.platformModelNode)
        self.platformModelNode = modelNode
        self.platformNode.value.addChildNode(platformModelNode)
        self.platformNode.value.position = self.position
    }
    
    private func renderPlatformNode() -> SCNNode? {
        if let platform = platformType {
            // Check for cached
            guard platform.scenePath != cachedPlatform else {
                return nil
            }
            
            // Attempt to render platform
            if let model = loadModel(platformType!.scenePath) {
                let modelNode = model
                cachedPlatform = platformType!.scenePath
                return modelNode
            } else {
                return nil
            }
        } else {
            // Platform type == nil
            
            // Check for cached
            guard cachedPlatform != "empty" else {
                return nil
            }
            
            // Render empty platform
            let size = self.size
            let platformBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size),
                                             length: CGFloat(size), chamferRadius: 0.05)
            for material in platformBoxGeometry.materials {
                material.diffuse.contents = UIImage(named: ReactiveGridNode.wireframeMaterial)
                material.lightingModel = .constant
                material.isDoubleSided = true
            }
            let modelNode = SCNNode(geometry: platformBoxGeometry)
            modelNode.position = SCNVector3(0.5 * size, 0.75 * size, -0.5 * size)
            cachedPlatform = "empty"
            return modelNode
        }
    }
    
    private func renderObstacleNode() -> SCNNode? {
        if let obstacle = obstacleType {
            // Check for cached
            guard obstacle.scenePath != cachedObstacle else {
                return nil
            }
            
            // Attempt to render obstacle
            if let model = loadModel(obstacleType!.scenePath) {
                let modelNode = model
                cachedObstacle = obstacleType!.scenePath
                return modelNode
            } else {
                return nil
            }
        } else {
            // Obstacle type == nil, return empty node
            let modelNode = SCNNode()
            return modelNode
        }
    }
    
    /// Called when observed obstacle TileModel changes.
    /// updates the obstacle node's model
    private func updateObstacleNode() {
        var modelNode: SCNNode
        
        guard shouldRender.value else {
            return
        }
        
        guard let model = renderObstacleNode() else {
            return
        }
        
        modelNode = model
        
        // Tag GridNode
        self.obstacleNode.value.name = GridViewModel.gridNodeName
        
        // Replace obstacleModelNode
        freeNode(self.obstacleModelNode)
        self.obstacleModelNode = modelNode
        self.obstacleNode.value.addChildNode(obstacleModelNode)
        self.obstacleNode.value.position = self.position + SCNVector3(0.0, size, 0.0)
    }
    
    /// Returns a model node that would be added to gridNode as a childnode
    private func loadModel(_ pathName: String?) -> SCNNode? {
        guard let path = pathName else {
            return nil
        }
        guard let modelScene = SCNScene(named: path) else {
            print("WARNING: Cant find path name: " + path)
            return nil
        }
        // Collect all child nodes in the scene model
        let modelNode = SCNNode()
        for childNode in modelScene.rootNode.childNodes {
            modelNode.addChildNode(childNode)
        }
        
        return modelNode
    }
    
    /// Remove all reference to node to free up memory
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
