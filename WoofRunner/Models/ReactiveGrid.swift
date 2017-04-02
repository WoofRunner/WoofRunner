//
//  ReactiveGrid.swift
//  WoofRunner
//
//  Created by See Soon Kiat on 24/3/17.
//  Copyright © 2017 WoofRunner. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

class ReactiveGrid {
    
    let disposeBag = DisposeBag()
    
    var gridNodes: [ReactiveGridNode]
    var grid: SCNNode
    
    init() {
        self.grid = SCNNode()
        self.gridNodes = [ReactiveGridNode]()
    }
    
    func setupGrid(gridNodes: [ReactiveGridNode]) {
        self.gridNodes = [ReactiveGridNode]()
        for gridNode in gridNodes {
            self.gridNodes.append(gridNode)
            
            if gridNode.shouldRender.value {
                grid.addChildNode(gridNode.platformNode.value)
                grid.addChildNode(gridNode.obstacleNode.value)
            }
            
            gridNode.shouldRender.asObservable()
            .subscribe(onNext: {
                (render) in
                if render {
                    self.grid.addChildNode(gridNode.platformNode.value)
                    self.grid.addChildNode(gridNode.obstacleNode.value)
                } else {
                    gridNode.platformNode.value.removeFromParentNode()
                    gridNode.obstacleNode.value.removeFromParentNode()
                }
            }).addDisposableTo(disposeBag)
        }
    }
    
    func removeGrid() {
        self.grid.removeFromParentNode()
    }
}
