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

class TileNode {
    
    let disposeBag = DisposeBag();
    
    var position: SCNVector3
    var size: Float
    var tileType: Int
    var obstacleType: Int?
    var tileBoxGeometry: SCNBox
    var obstacleBoxGeometry: SCNBox?
    var shouldRender: Bool
    
    init(_ tileVM: TileViewModel) {
        
        self.position = tileVM.position.value
        self.shouldRender = tileVM.shouldRender.value
        self.size = tileVM.size.value
        self.tileType = tileVM.tileType.value
        self.obstacleType = tileVM.obstacleType?.value
        self.tileBoxGeometry = SCNBox()
        updateTileBoxGeometry()
        updateObstacleBoxGeometry()
        
        // Subscribe to observables
        tileVM.position.asObservable()
            .subscribe(onNext: {
                (pos) in
                self.position = pos
            }).addDisposableTo(disposeBag)
        
        tileVM.shouldRender.asObservable()
            .subscribe(onNext: {
                (render) in
                self.shouldRender = render
            }).addDisposableTo(disposeBag)
        
        tileVM.size.asObservable()
            .subscribe(onNext: {
                (size) in
                self.size = size
                self.updateTileBoxGeometry()
                self.updateObstacleBoxGeometry()
            }).addDisposableTo(disposeBag)
        
        tileVM.tileType.asObservable()
            .subscribe(onNext: {
                (tileType) in
                self.tileType = tileType
                self.updateTileBoxGeometry()
            }).addDisposableTo(disposeBag)
        
        tileVM.obstacleType?.asObservable()
            .subscribe(onNext: {
                (obstacleType) in
                self.obstacleType = obstacleType
                self.updateObstacleBoxGeometry()
            }).addDisposableTo(disposeBag)
    }
    
    private func updateTileBoxGeometry() {
        tileBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0.05)
        for material in tileBoxGeometry.materials {
            switch tileType {
            case 0:
                material.ambient.contents = UIColor.lightGray
                material.transparency = 0.5
                break
            case 1:
                material.emission.contents = UIColor.white
                material.transparency = 1
                break
            case 2:
                material.emission.contents = UIColor.red
                material.transparency = 1
                break
            case 3:
                material.emission.contents = UIColor.blue
                material.transparency = 1
                break
            default:
                material.ambient.contents = UIColor.lightGray
                material.transparency = 0.5
                break
            }
        }
    }
    
    private func updateObstacleBoxGeometry() {
        tileBoxGeometry = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0.05)
        for material in tileBoxGeometry.materials {
            guard let type = obstacleType else {
                material.ambient.contents = UIColor.lightGray
                material.transparency = 0
                continue
            }
            switch type {
            case 0:
                material.ambient.contents = UIColor.lightGray
                material.transparency = 1
                break
            case 1:
                material.emission.contents = UIColor.white
                material.transparency = 1
                break
            case 2:
                material.emission.contents = UIColor.red
                material.transparency = 1
                break
            case 3:
                material.emission.contents = UIColor.blue
                material.transparency = 1
                break
            default:
                material.ambient.contents = UIColor.lightGray
                material.transparency = 0
                break
            }
        }
    }
}
