//
//  TileViewModel.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 22/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

class TileViewModel {
    
    var position = Variable<SCNVector3>(SCNVector3(0, 0, 0))
    var size = Variable<Float>(1.0)
    var tileType = Variable<Int>(0)
    var obstacleType: Variable<Int>?
    var shouldRender = Variable<Bool>(false)
    
    static var colors = [UIColor.blue, UIColor.red, UIColor.lightGray]
    
    init(_ tileModel: TileStub) {
        
        self.position = Variable<SCNVector3>(tileModel.position)
        self.size = Variable<Float>(tileModel.size)
        self.tileType = Variable<Int>(tileModel.tileType)
        
//        tileModel.position.asObservable()
//            .subscribe(onNext: { (pos) in
//                self.position = pos;
//            }).addDisposableTo(disposeBag)
        
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
    }
    
//    func update(gridModel: GridStub) -> Bool {
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
//  }
}

class TileStub {
    
    var position: SCNVector3
    var size: Float
    var tileType: Int
    var obstacle: ObstacleStub?
    
    init(position: SCNVector3, size: Float, tileType: Int) {
        self.position = position
        self.size = size
        self.tileType = tileType
    }
}

class ObstacleStub {
    
    var obstacleType: Int
    
    init(obstacleType: Int) {
        self.obstacleType = obstacleType
    }
}
