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
    var groundNode = Variable<SCNNode>(SCNNode())
    var obstacleNode = Variable<SCNNode>(SCNNode())
    
    var position: SCNVector3
    var size: Float
    var groundType: GroundType?
    var obstacleType: ObstacleType?
    var groundBoxGeometry: SCNBox
    var obstacleBoxGeometry: SCNBox
    
    
    init(_ gridVM: GridViewModel) {
        
        self.position = gridVM.position.value
        self.size = gridVM.size.value
        self.groundType = gridVM.groundType.value
        self.obstacleType = gridVM.obstacleType.value
        self.groundBoxGeometry = SCNBox()
        self.obstacleBoxGeometry = SCNBox()
        
        self.groundNode.value = SCNNode(geometry: groundBoxGeometry)
        self.obstacleNode.value = SCNNode(geometry: obstacleBoxGeometry)
        self.shouldRender = gridVM.shouldRender
        
        updateGroundBoxGeometry()
        updateObstacleBoxGeometry()
        
        // Subscribe to observables
        gridVM.position.asObservable()
            .subscribe(onNext: {
                (pos) in
                self.position = pos
                self.groundNode.value.position = pos
                self.obstacleNode.value.position = pos + SCNVector3(0, 0, Tile.TILE_WIDTH)
            }).addDisposableTo(disposeBag)
        
        gridVM.size.asObservable()
            .subscribe(onNext: {
                (size) in
                self.size = size
                self.updateGroundBoxGeometry()
                self.updateObstacleBoxGeometry()
            }).addDisposableTo(disposeBag)
        
        gridVM.groundType.asObservable()
            .subscribe(onNext: {
                (groundType) in
                self.groundType = groundType
                self.updateGroundBoxGeometry()
            }).addDisposableTo(disposeBag)
        
        gridVM.obstacleType.asObservable()
            .subscribe(onNext: {
                (obstacleType) in
                self.obstacleType = obstacleType
                self.updateObstacleBoxGeometry()
            }).addDisposableTo(disposeBag)
    }
    
    private func updateGroundBoxGeometry() {
        groundBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0.05)
        if groundType == nil {
            // Empty Grid
            for material in groundBoxGeometry.materials {
                material.emission.contents = UIColor.lightGray
                material.transparency = 0.5
            }
        } else {
            guard let type = groundType else {
                return
            }
            for material in groundBoxGeometry.materials {
                switch type {
                case .grass:
                    material.emission.contents = UIColor.green
                    material.transparency = 1
                    break
                case .soil:
                    material.emission.contents = UIColor.brown
                    material.transparency = 1
                    break
//                default:
//                    material.ambient.contents = UIColor.lightGray
//                    material.transparency = 0.5
//                    break
                }
            }
        }
        
        self.groundNode.value.geometry = groundBoxGeometry
    }
    
    private func updateObstacleBoxGeometry() {
        obstacleBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0.05)
        if obstacleType == nil {
            // Empty Obstacle
            for material in obstacleBoxGeometry.materials {
                material.emission.contents = UIColor.purple
                material.transparency = 0
            }
        } else {
            guard let type = obstacleType else {
                return
            }
            for material in obstacleBoxGeometry.materials {
                switch type {
                case .jump:
                    material.ambient.contents = UIColor.orange
                    material.transparency = 1
                    break
                case .rock:
                    material.emission.contents = UIColor.red
                    material.transparency = 1
                    break
                case .sword:
                    material.emission.contents = UIColor.blue
                    material.transparency = 1
                    break
//                default:
//                    material.ambient.contents = UIColor.lightGray
//                    material.transparency = 0
//                    break
                }
            }
        }
        
        self.obstacleNode.value.geometry = obstacleBoxGeometry
    }
}
