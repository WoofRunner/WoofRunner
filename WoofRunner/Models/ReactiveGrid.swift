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
            
            // Check if initial value is should render
            if gridNode.shouldRender.value {
                grid.addChildNode(gridNode.platformNode.value)
                grid.addChildNode(gridNode.obstacleNode.value)
            }
            
            setupObservables(gridNode)
        }
    }
    
    func extendGrid(extendedGridNodes: [ReactiveGridNode]) {
        self.gridNodes.append(contentsOf: extendedGridNodes)
        for gridNode in extendedGridNodes {
            
            // Check if initial value is should render
            if gridNode.shouldRender.value {
                grid.addChildNode(gridNode.platformNode.value)
                grid.addChildNode(gridNode.obstacleNode.value)
            }
            
            setupObservables(gridNode)
        }
    }
    
    func removeGrid() {
        self.grid.removeFromParentNode()
    }
    
    private func setupObservables(_ gridNode: ReactiveGridNode) {
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
