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
    var platformBoxGeometry: SCNBox
    var obstacleBoxGeometry: SCNBox
    
    
    init(_ gridVM: GridViewModel) {
        
        self.position = SCNVector3(Float(gridVM.gridPos.value.getCol()) * Tile.TILE_WIDTH,
                                   Float(gridVM.gridPos.value.getRow()) * Tile.TILE_WIDTH, 0)
        self.size = gridVM.size.value
        self.platformType = gridVM.platformType.value
        self.obstacleType = gridVM.obstacleType.value
        self.platformBoxGeometry = SCNBox()
        self.obstacleBoxGeometry = SCNBox()
        
        self.platformNode.value = SCNNode(geometry: platformBoxGeometry)
        self.obstacleNode.value = SCNNode(geometry: obstacleBoxGeometry)
        self.shouldRender = gridVM.shouldRender
        
        updatePlatformBoxGeometry()
        updateObstacleBoxGeometry()
        
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
                self.updatePlatformBoxGeometry()
                self.updateObstacleBoxGeometry()
            }).addDisposableTo(disposeBag)
        
        gridVM.platformType.asObservable()
            .subscribe(onNext: {
                (platformType) in
                self.platformType = platformType
                self.updatePlatformBoxGeometry()
            }).addDisposableTo(disposeBag)
        
        gridVM.obstacleType.asObservable()
            .subscribe(onNext: {
                (obstacleType) in
                self.obstacleType = obstacleType
                self.updateObstacleBoxGeometry()
            }).addDisposableTo(disposeBag)
    }
    
    private func updatePlatformBoxGeometry() {
        platformBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0.05)
        for material in platformBoxGeometry.materials {
            switch platformType {
            case .none:
                material.emission.contents = UIColor.lightGray
                material.transparency = 0.5
                break;
            case .grass:
                material.emission.contents = UIColor.green
                material.transparency = 1
                break
            case .floorLight:
                material.emission.contents = UIColor.brown
                material.transparency = 1
                break
            default:
                material.ambient.contents = UIColor.lightGray
                material.transparency = 0.5
                break
            }
        }
        
        self.platformNode.value.geometry = platformBoxGeometry
    }
    
    private func updateObstacleBoxGeometry() {
        obstacleBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0.05)
        for material in obstacleBoxGeometry.materials {
            switch obstacleType {
            case .none:
                material.emission.contents = UIColor.purple
                material.transparency = 0
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
            default:
                material.ambient.contents = UIColor.lightGray
                material.transparency = 0
                break
            }
        }
        
        self.obstacleNode.value.geometry = obstacleBoxGeometry
        self.obstacleNode.value.position = self.position + SCNVector3(0, 0, Tile.TILE_WIDTH)
    }
}
